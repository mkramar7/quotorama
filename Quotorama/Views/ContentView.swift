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
    
    @State private var interstitialCounter = 0
    
    var body: some View {
        VStack {
            HeaderView(currentQuote: currentQuote)
                .environmentObject(quotesStore)
            
            Spacer()
            
            QuoteView(currentQuote: $currentQuote, nextQuoteShownHandler: onNextQuoteShown)
                .environmentObject(quotesStore)
            
            Spacer()
        }
        .onAppear(perform: QuotoramaUtil.loadGoogleInterstitialAd)
    }
    
    func onNextQuoteShown() {
        interstitialCounter += 1
        if (interstitialCounter == 7) {
            QuotoramaUtil.showGoogleInterstitialAd()
            interstitialCounter = 0
        }
    }
}

struct HeaderView: View {
    @EnvironmentObject var quotesStore: QuotesStore
    @State private var favoritesViewShown = false
    
    var currentQuote: Quote
    
    var body: some View {
        HStack {
            QuotoramaButtonView(text: "Favorites", icon: "heart.fill", action: { favoritesViewShown = true })
                .padding(.top, 20)
                .padding(.leading, 20)
                .sheet(isPresented: $favoritesViewShown) {
                    FavoritesView()
                        .preferredColorScheme(.dark)
                        .environmentObject(quotesStore)
                }
            
            Spacer()
            
            QuotoramaButtonView(text: "Share", icon: "square.and.arrow.up", action: shareQuote)
                .padding(.top, 20)
                .padding(.trailing, 20)
        }
    }
    
    func shareQuote() {
        let data = "„\(currentQuote.text)“ by \(currentQuote.author)"
        let shareView = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(shareView, animated: true, completion: nil)
    }
}