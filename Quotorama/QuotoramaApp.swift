//
//  QuotoramaApp.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI
import UIKit

@main
struct QuotoramaApp: App {
    @State private var quotesStore = QuotesStore()

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        if let largeFont = UIFont(name: "Futura", size: 30) {
            appearance.largeTitleTextAttributes = [.font: largeFont]
        }
        if let inlineFont = UIFont(name: "Futura", size: 17) {
            appearance.titleTextAttributes = [.font: inlineFont]
        }
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environment(quotesStore)
        }
    }
}
