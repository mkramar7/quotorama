//
//  FavoritesView.swift
//  Quotorama
//
//  Created by Marko Kramar on 28.12.2020..
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var quotesStore: QuotesStore
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(quotesStore.quotes.prefix(10)) { favoriteQuote in
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
                        .padding()
                        .background(Color.gray.opacity(0.30))
                        .cornerRadius(15)
                    }
                    .onDelete(perform: quotesStore.removeFavorites)
                }
                .padding(.horizontal, 10)
            }
            .font(Util.appFont(20))
            .padding(.top, 10)
            .navigationBarTitle("Favorites")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .preferredColorScheme(.dark)
    }
}

struct Favoritesiew_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(QuotesStore())
            .preferredColorScheme(.dark)
    }
}
