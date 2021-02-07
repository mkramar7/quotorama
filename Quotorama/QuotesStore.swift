//
//  QuotesStore.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI

class QuotesStore: ObservableObject {
    @AppStorage("favoriteQuotes") var favoriteQuoteIds: [String]  = []
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
    
    func getFavoriteQuotes() -> [Quote] {
        var favQuotes: [Quote] = []
        for quote in quotes {
            for favQuoteId in favoriteQuoteIds {
                if favQuoteId == quote.id {
                    favQuotes.append(quote)
                }
            }
        }
        
        return favQuotes
    }
    
    func isFavorite(_ quote: Quote) -> Bool {
        favoriteQuoteIds.contains(where: { $0 == quote.id })
    }
    
    func makeFavorite(_ quote: Quote) {
        objectWillChange.send()
        favoriteQuoteIds.append(quote.id)
    }
    
    func removeFavorites(at offsets: IndexSet) {
        objectWillChange.send()
        
        var idsToRemove: [String] = []
        for index in offsets {
            let quoteIdToRemoveFromFavorites = getFavoriteQuotes()[index].id
            idsToRemove.append(quoteIdToRemoveFromFavorites)
        }
        
        favoriteQuoteIds.removeAll(where: { idsToRemove.contains($0) })
    }
}
