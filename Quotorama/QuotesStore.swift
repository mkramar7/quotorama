//
//  QuotesStore.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import Foundation

class QuotesStore: ObservableObject {
    @Published var quotes: [Quote] = Bundle.main.decode("quotes.json")
    
    func getNextQuote() -> Quote {
        quotes.shuffled().randomElement() ?? Quote(author: "Unknown author", text: "Unknown quote")
    }
    
    func toggleFavorite(_ quote: Quote) {
        objectWillChange.send()
        if var quoteToChange = quotes.first(where: { $0.id == quote.id }) {
            if let favorited = quoteToChange.isFavorite {
                quoteToChange.isFavorite = !favorited
            } else {
                quoteToChange.isFavorite = true
            }
        }
    }
}
