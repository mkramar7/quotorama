//
//  Store.swift
//  Quotorama
//
//  Created by Marko Kramar on 15.03.2021..
//

import StoreKit

typealias FetchCompletionHandler = (([SKProduct]) -> Void)
typealias PurchaseCompletionHandler = ((SKPaymentTransaction?) -> Void)

class InAppPurchaseHelper: NSObject, ObservableObject {
    @Published var allInAppPurchases = [InAppPurchase]()
    
    private let allProductIdentifiers = Set([
        Constants.REMOVE_ADS_IN_APP_PURCHASE_IDENTIFIER
    ])
    
    private var completedPurchases = [String]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                for index in self.allInAppPurchases.indices {
                    if !self.completedPurchases.contains(self.allInAppPurchases[index].id) {
                        continue
                    }
                    
                    self.allInAppPurchases[index].isLocked = false
                    Util.markIapAsPurchased(iapIdentifier: self.allInAppPurchases[index].id)
                }
            }
        }
    }
    
    private var productsRequest: SKProductsRequest?
    private var fetchedProducts = [SKProduct]()
    private var fetchCompletionHandler: FetchCompletionHandler?
    private var purchaseCompletionHandler: PurchaseCompletionHandler?
    
    override init() {
        super.init()
        
        startObservingPaymentQueue()
        
        fetchProducts { products in
            self.allInAppPurchases = products.map { InAppPurchase(product: $0, isLocked: !Util.isIapPurchased(iapIdentifier: $0.productIdentifier)) }
        }
    }
    
    private func startObservingPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
    
    private func fetchProducts(_ completion: @escaping FetchCompletionHandler) {
        guard productsRequest == nil else {
            return
        }
        
        fetchCompletionHandler = completion
        productsRequest = SKProductsRequest(productIdentifiers: allProductIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    private func buy(_ product: SKProduct, completion: @escaping PurchaseCompletionHandler) {
        purchaseCompletionHandler = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension InAppPurchaseHelper {
    func product(for identifier: String) -> SKProduct? {
        fetchedProducts.first(where: { $0.productIdentifier == identifier })
    }
    
    func purchaseProduct(_ product: SKProduct) {
        startObservingPaymentQueue()
        
        buy(product) { _ in }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension InAppPurchaseHelper: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            var shouldFinishTransactions = false
            
            switch transaction.transactionState {
            case .purchased, .restored:
                completedPurchases.append(transaction.payment.productIdentifier)
                shouldFinishTransactions = true
            case .failed:
                shouldFinishTransactions = true
            case .purchasing, .deferred:
                break
            @unknown default:
                break
            }
            
            if shouldFinishTransactions {
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchaseCompletionHandler?(transaction)
                    self.purchaseCompletionHandler = nil
                }
            }
        }
    }
}

extension InAppPurchaseHelper: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let loadedProducts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        
        guard !loadedProducts.isEmpty else {
            print("Could not load the products")
            if !invalidProducts.isEmpty {
                print("Invalid products found: \(invalidProducts)")
            }
            
            productsRequest = nil
            return
        }
        
        // Cache the fetched products
        fetchedProducts = loadedProducts
        
        // Notify anyone waiting on the product load
        DispatchQueue.main.async {
            self.fetchCompletionHandler?(loadedProducts)
            self.fetchCompletionHandler = nil
            self.productsRequest = nil
        }
    }
}

struct InAppPurchase: Hashable {
    let id: String
    let title: String
    let description: String
    var isLocked: Bool
    let locale: Locale
    var price: String?
    
    lazy var formatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = locale
        return nf
    }()
    
    init(product: SKProduct, isLocked: Bool = true) {
        self.id = product.productIdentifier
        self.title = product.localizedTitle
        self.description = product.localizedDescription
        self.isLocked = isLocked
        self.locale = product.priceLocale
        
        if isLocked {
            self.price = formatter.string(from: product.price)
        }
    }
}
