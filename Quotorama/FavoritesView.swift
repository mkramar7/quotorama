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
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Futura", size: 30)!]
    }
    
    var body: some View {
        NavigationView {
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
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }.font(Util.appFont(17)))
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
