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
    
    @AppStorage("tutorialNotShownYet") var tutorialNotShownYet = true
    
    @State var currentQuote: Quote
    @State private var favoritesViewShown = false
    @State private var shareSheetViewShown = false
    
    @State private var tutorialViewShown = false
    
    var body: some View {
        ZStack {
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
            
            if tutorialViewShown {
                TutorialView(viewShown: $tutorialViewShown)
            }
        }
        .onAppear(perform: {
            QuotoramaUtil.loadGoogleInterstitialAd()
            if (!tutorialNotShownYet) {
                tutorialViewShown = true
                tutorialNotShownYet = false
            }
        })

    }
}
