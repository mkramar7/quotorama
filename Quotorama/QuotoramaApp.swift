//
//  QuotoramaApp.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI

@main
struct QuotoramaApp: App {
    private var iapHelper = InAppPurchaseHelper()
    private var quotesStore = QuotesStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(quotesStore)
                .environmentObject(iapHelper)
        }
    }
}
