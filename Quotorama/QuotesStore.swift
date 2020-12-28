//
//  QuotesStore.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI

class QuotesStore: ObservableObject {
    @Published var quotes: [Quote] = Bundle.main.decode("quotes.json")
    
    func getNextQuote() -> Quote {
        quotes.shuffled().randomElement()!
    }
    
    func toggleFavorite(_ quote: Binding<Quote>) {
        if let favoriteQuoteIndex = quotes.firstIndex(where: { $0.id == quote.wrappedValue.id }) {
            objectWillChange.send()
            quotes[favoriteQuoteIndex].isFavorite.toggle()
            quote.wrappedValue.isFavorite.toggle()
        }
    }
}
