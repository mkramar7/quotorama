//
//  ContentView.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI

struct ContentView: View {
    var quotesStore = QuotesStore()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(QuotoramaConstants.yellowishColor)
    }
    
    var body: some View {
        TabView {
            QuoteView(currentQuote: quotesStore.nextQuote)
                .tabItem {
                    Image(systemName: "quote.bubble")
                    Text("Quote")
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
        }
        .environmentObject(quotesStore)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
