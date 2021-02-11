//
//  Quote.swift
//  Quotorama
//
//  Created by Marko Kramar on 11.02.2021..
//

import Foundation

struct Quote: Identifiable, Codable {
    var id: String
    var author: String
    var text: String
}
