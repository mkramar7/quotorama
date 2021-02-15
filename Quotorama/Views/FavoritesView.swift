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
                ForEach(quotesStore.favoriteQuotes) { favoriteQuote in
                    VStack(alignment: .leading) {
                        Text(favoriteQuote.text)
                            .padding(.bottom, 5)
                        
                        HStack {
                            Spacer()
                            
                            Text(favoriteQuote.author)
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    }
                    .frame(minHeight: 100)
                }
                .onDelete(perform: quotesStore.removeFavorites)
            }
            .navigationBarTitle("Favorite quotes")
        }
    }
}
