//
//  InAppPurchase.swift
//  Quotorama
//
//  Created by Marko Kramar on 15.03.2021..
//

import Foundation
import StoreKit

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
