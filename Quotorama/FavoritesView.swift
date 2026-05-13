//
//  FavoritesView.swift
//  Quotorama
//
//  Created by Marko Kramar on 28.12.2020..
//

import SwiftUI

struct FavoritesView: View {
    @Environment(QuotesStore.self) var quotesStore
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(quotesStore.favoriteQuotes) { favoriteQuote in
                    VStack(alignment: .leading) {
                        Text(favoriteQuote.text)
                            .padding(.bottom, 5)
                            .font(Util.appFont(17))

                        HStack {
                            Spacer()

                            Text(favoriteQuote.author)
                                .foregroundColor(.secondary)
                                .italic()
                                .font(Util.appFont(14))
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.30))
                    .cornerRadius(10)
                }
                .onDelete(perform: quotesStore.removeFavorites)
            }
            .listStyle(SidebarListStyle())
            .listRowInsets(.init(top: -10, leading: 0, bottom: 0, trailing: 0))
            .padding(.horizontal, -10)
            .navigationBarTitle("Favorites", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    DismissSheetButtonView { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    FavoritesView()
        .environment(QuotesStore())
        .preferredColorScheme(.dark)
}
