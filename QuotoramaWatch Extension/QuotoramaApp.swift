//
//  QuotoramaApp.swift
//  QuotoramaWatch Extension
//
//  Created by Marko Kramar on 11.02.2021..
//

import SwiftUI

@main
struct QuotoramaApp: App {
    var quotesStore = QuotesStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(currentQuote: quotesStore.nextQuote)
            }
            .environmentObject(quotesStore)
        }
    }
}
