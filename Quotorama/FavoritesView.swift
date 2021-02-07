//
//  FavoritesView.swift
//  Quotorama
//
//  Created by Marko Kramar on 28.12.2020..
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var quotesStore: QuotesStore
    
    init() {
        UITableView.appearance().backgroundColor = .clear // For tableView
        UITableViewCell.appearance().backgroundColor = .clear // For tableViewCell
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(quotesStore.getFavoriteQuotes()) { favoriteQuote in
                    VStack(alignment: .leading) {
                        Text(favoriteQuote.text)
                            .font(.body)
                            .padding(.bottom, 5)
                        
                        HStack {
                            Spacer()
                            
                            Text(favoriteQuote.author)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    }
                    .listRowBackground(Color.black.opacity(0.1))
                }
                .onDelete(perform: quotesStore.removeFavorites)
            }
            .background(Image("background"))
            .navigationBarTitle("Favorites")
        }
    }
}
