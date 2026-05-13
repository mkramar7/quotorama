//
//  QuotesStore.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import Foundation
import Observation

@Observable
final class QuotesStore {
    var quotes: [Quote]
    var favoriteQuoteIds: [String] {
        didSet { Self.persistFavorites(favoriteQuoteIds) }
    }

    init() {
        self.quotes = (Bundle.main.decode("quotes.json") as [Quote]).shuffled()
        self.favoriteQuoteIds = Self.loadFavorites()
    }

    var favoriteQuotes: [Quote] {
        quotes.filter { favoriteQuoteIds.contains($0.id) }
    }

    func isFavorite(_ quote: Quote) -> Bool {
        favoriteQuoteIds.contains(quote.id)
    }

    func toggleFavorite(_ quote: Quote) {
        if favoriteQuoteIds.contains(quote.id) {
            favoriteQuoteIds.removeAll { $0 == quote.id }
        } else {
            favoriteQuoteIds.append(quote.id)
        }
    }

    func removeFavorites(at offsets: IndexSet) {
        let ids = offsets.map { favoriteQuotes[$0].id }
        favoriteQuoteIds.removeAll { ids.contains($0) }
    }

    private static let favoritesKey = "favoriteQuoteIds"

    // Reads favorites stored by the legacy @AppStorage + Array+RawRepresentable encoding
    // (a JSON-encoded String in UserDefaults). Preserves data from older app versions.
    private static func loadFavorites() -> [String] {
        guard let raw = UserDefaults.standard.string(forKey: favoritesKey),
              let data = raw.data(using: .utf8),
              let ids = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        return ids
    }

    private static func persistFavorites(_ ids: [String]) {
        guard let data = try? JSONEncoder().encode(ids),
              let raw = String(data: data, encoding: .utf8) else { return }
        UserDefaults.standard.set(raw, forKey: favoritesKey)
    }
}

struct Quote: Identifiable, Codable, Hashable {
    var id: String
    var author: String
    var text: String
}
