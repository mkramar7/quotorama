//
//  Quote.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import Foundation

struct Quote: Identifiable, Codable {
    let id = UUID()
    var author: String?
    var text: String?
    var authorForUrl: String {
        guard let authorName = author else { return "" }
        return authorName.replacingOccurrences(of: " ", with: "_")
    }
}
