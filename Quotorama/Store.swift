//
//  Store.swift
//  Quotorama
//
//  Created by Marko Kramar on 15.03.2021..
//

import StoreKit

typealias FetchCompletionHandler = (([SKProduct]) -> Void)
typealias PurchaseCompletionHandler = ((SKPaymentTransaction?) -> Void)

class Store: NSObject, ObservableObject {
    @Published var allInAppPurchases = [InAppPurchase]()
    
    private let allProductIdentifiers = Set([
        Constants.REMOVE_ADS_IN_APP_PURCHASE_IDENTIFIER
    ])
    
    private var completedPurchases = [String]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                for index in self.allInAppPurchases.indices {
                    self.allInAppPurchases[index].isLocked = !self.completedPurchases.contains(self.allInAppPurchases[index].id)
                    if !self.allInAppPurchases[index].isLocked {
                        Util.markIapAsPurchased(iapIdentifier: self.allInAppPurchases[index].id)
                    }
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

extension Store {
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

extension Store: SKPaymentTransactionObserver {
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

extension Store: SKProductsRequestDelegate {
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
