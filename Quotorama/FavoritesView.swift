//
//  FavoritesView.swift
//  Quotorama
//
//  Created by Marko Kramar on 28.12.2020..
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var quotesStore: QuotesStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(quotesStore.quotes.filter({ $0.isFavorite })) { favoriteQuote in
                    VStack(alignment: .leading) {
                        Text(favoriteQuote.text)
                            .font(.subheadline)
                        Text(favoriteQuote.author)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationBarTitle("Favorites")
        }
    }
}
