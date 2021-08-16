//
//  HeaderView.swift
//  Quotorama
//
//  Created by Marko Kramar on 16.03.2021..
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var quotesStore: QuotesStore
    
    @State private var favoritesViewShown = false
    @State private var aboutViewShown = false
    
    var body: some View {
        HStack {
            ActionButtonView(text: "Favorites", icon: "hand.thumbsup.fill", action: { favoritesViewShown.toggle() })
                .padding([.top, .leading], 20)
                .sheet(isPresented: $favoritesViewShown) {
                    FavoritesView().environmentObject(quotesStore)
                }
            
            Spacer()
            
            ActionButtonView(text: "About", icon: "info.circle", action: { aboutViewShown.toggle() })
                .padding([.top, .trailing], 20)
                .sheet(isPresented: $aboutViewShown) {
                    AboutView().environmentObject(quotesStore)
                }
        }
    }
}
