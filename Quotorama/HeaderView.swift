//
//  HeaderView.swift
//  Quotorama
//
//  Created by Marko Kramar on 16.03.2021..
//

import SwiftUI

struct HeaderView: View {
    @State private var favoritesViewShown = false
    @State private var aboutViewShown = false

    var body: some View {
        HStack {
            ActionButtonView(text: "Favorites", icon: "hand.thumbsup.fill") { favoritesViewShown.toggle() }
                .padding([.top, .leading], 20)
                .sheet(isPresented: $favoritesViewShown) {
                    FavoritesView()
                }

            Spacer()

            ActionButtonView(text: "About", icon: "info.circle") { aboutViewShown.toggle() }
                .padding([.top, .trailing], 20)
                .sheet(isPresented: $aboutViewShown) {
                    AboutView()
                }
        }
    }
}
