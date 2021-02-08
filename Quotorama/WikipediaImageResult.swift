//
//  WikipediaImageResult.swift
//  Quotorama
//
//  Created by Marko Kramar on 07.02.2021..
//

import Foundation

struct WikipediaImageResult: Codable {
    var query: Query
    
    struct Query: Codable {
        var pages: [Page]
    }

    struct Page: Codable {
        var thumbnail: Thumbnail
    }

    struct Thumbnail: Codable {
        var source: String
    }
}
