//
//  Quote.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import Foundation

struct Quote: Identifiable, Codable {
    var id: String?
    var author: String
    var text: String
    var isFavorite: Bool
    var authorForUrl: String {
        return author.replacingOccurrences(of: " ", with: "_")
    }
}
