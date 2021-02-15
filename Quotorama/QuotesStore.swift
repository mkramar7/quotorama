//
//  QuotesStore.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI

class QuotesStore: ObservableObject {
    @AppStorage("favoriteQuoteIds") var favoriteQuoteIds: [String]  = []
    @Published var quotes: [Quote] = Bundle.main.decode("quotes.json")
    
    var nextQuote: Quote {
        quotes.shuffled().randomElement()!
    }
    
    var favoriteQuotes: [Quote] {
        quotes.filter({ favoriteQuoteIds.contains($0.id) })
    }
    
    func isFavorite(_ quote: Quote) -> Bool {
        favoriteQuoteIds.contains(where: { $0 == quote.id })
    }
    
    func toggleFavorite(_ quote: Quote) {
        objectWillChange.send()
        if favoriteQuoteIds.contains(quote.id) {
            favoriteQuoteIds.removeAll(where: { $0 == quote.id })
        } else {
            favoriteQuoteIds.append(quote.id)
        }
    }
    
    func removeFavorites(at offsets: IndexSet) {
        objectWillChange.send()
        let quoteIdsToRemoveFromFavorites = offsets.map({ favoriteQuotes[$0].id })
        favoriteQuoteIds.removeAll(where: { quoteIdsToRemoveFromFavorites.contains($0) })
    }
}

struct Quote: Identifiable, Codable, Hashable {
    var id: String
    var author: String
    var text: String
    var authorNameNormalized: String {
        return author.replacingOccurrences(of: " ", with: "_")
    }
}
