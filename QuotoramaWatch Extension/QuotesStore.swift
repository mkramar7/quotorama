//
//  QuotesStore.swift
//  QuotoramaWatch Extension
//
//  Created by Marko Kramar on 11.02.2021..
//

import Foundation

class QuotesStore: ObservableObject {
    @Published var quotes: [Quote] = Bundle.main.decode("quotes.json")
    
    var nextQuote: Quote {
        quotes.shuffled().randomElement()!
    }
}

struct Quote: Identifiable, Codable {
    var id: String
    var author: String
    var text: String
}
