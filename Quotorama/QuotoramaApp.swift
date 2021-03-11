//
//  QuotoramaApp.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI

@main
struct QuotoramaApp: App {
    var quotesStore = QuotesStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView(currentQuote: quotesStore.nextQuote)
                .preferredColorScheme(.dark)
                .environmentObject(quotesStore)

            /*ContentView2()
                .preferredColorScheme(.dark)
                .environmentObject(quotesStore)*/
        }
    }
}
