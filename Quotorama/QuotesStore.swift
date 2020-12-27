//
//  QuotesStore.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import Foundation

class QuotesStore: ObservableObject {
    static let quotes: [Quote] = Bundle.main.decode("quotes.json")
    
    static func getNextQuote() -> Quote {
        quotes.shuffled().randomElement() ?? Quote(author: "Unknown author", text: "Unknown quote")
    }
}
