//
//  HeaderView.swift
//  Quotorama
//
//  Created by Marko Kramar on 16.03.2021..
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var iapHelper: InAppPurchaseHelper
    @EnvironmentObject var quotesStore: QuotesStore
    
    @State private var favoritesViewShown = false
    @State private var settingsViewShown = false
    
    var body: some View {
        HStack {
            ActionButtonView(text: "Favorites", icon: "hand.thumbsup.fill", action: { favoritesViewShown.toggle() })
                .padding([.top, .leading], 20)
                .sheet(isPresented: $favoritesViewShown, onDismiss: showAdRandomly) {
                    FavoritesView().environmentObject(quotesStore)
                }
            
            Spacer()
            
            ActionButtonView(text: "Settings", icon: "gearshape", action: { settingsViewShown.toggle() })
                .padding([.top, .trailing], 20)
                .sheet(isPresented: $settingsViewShown) {
                    SettingsView().environmentObject(iapHelper).environmentObject(quotesStore)
                }
        }
    }
    
    func showAdRandomly() {
        if !Util.isAdsRemovalPurchased() {
            if Int.random(in: 1...5) == 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Util.showGoogleInterstitialAd()
                }
            }
        }
    }
}
