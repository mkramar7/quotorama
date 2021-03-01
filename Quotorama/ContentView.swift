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
    
    @State private var interstitialAd: GADInterstitialAd!
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
        .onAppear(perform: loadGoogleInterstitialAd)
    }
    
    func onNextQuoteShown() {
        interstitialCounter += 1
        if (interstitialCounter == 7) {
            showGoogleInterstitialAd()
            interstitialCounter = 0
        }
    }
    
    func showGoogleInterstitialAd() {
        self.interstitialAd.present(fromRootViewController: (UIApplication.shared.windows.first?.rootViewController)!)
    }
    
    func loadGoogleInterstitialAd() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-2246687869317180/5429182192", request: request) { [self] ad, error in
            if let error = error {
              print("Failed to load interstitial ad with error: \(error.localizedDescription)")
              return
            }

            self.interstitialAd = ad
            let randomNumber = Int.random(in: 0...100)
            if randomNumber % 4 == 0 {
                showGoogleInterstitialAd()
            }
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
