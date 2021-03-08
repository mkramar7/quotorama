//
//  QuoteView.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI
import GoogleMobileAds

struct ContentView: View {
    @EnvironmentObject var quotesStore: QuotesStore
    
    @State var currentQuote: Quote
    @State private var favoritesViewShown = false
    @State private var shareSheetViewShown = false
    
    var body: some View {
        VStack {
            HStack {
                ActionButtonView(text: "Favorites", icon: "heart.fill", action: { favoritesViewShown.toggle() })
                    .padding([.top, .leading], 20)
                    .sheet(isPresented: $favoritesViewShown) {
                        FavoritesView().environmentObject(quotesStore)
                    }
                
                Spacer()
                
                ActionButtonView(text: "Share", icon: "square.and.arrow.up", action: { shareSheetViewShown.toggle() })
                    .padding([.top, .trailing], 20)
                    .sheet(isPresented: $shareSheetViewShown) {
                        ShareSheetView(activityItems: ["„\(currentQuote.text)“ by \(currentQuote.author)"])
                    }
            }
            
            Spacer()
            
            QuoteView(currentQuote: $currentQuote)
                .environmentObject(quotesStore)
            
            Spacer()
        }
        .onAppear(perform: QuotoramaUtil.loadGoogleInterstitialAd)
    }
}
