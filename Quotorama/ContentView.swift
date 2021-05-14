//
//  QuotesView.swift
//  Quotorama
//
//  Created by Marko Kramar on 08.03.2021..
//

import SwiftUI
import AppTrackingTransparency

struct ContentView: View {
    @EnvironmentObject var iapHelper: InAppPurchaseHelper
    @EnvironmentObject var quotesStore: QuotesStore
    
    @AppStorage("appThemeImage") var appThemeImage: String = ""
    
    var body: some View {
        VStack {
            HeaderView()
                .environmentObject(iapHelper)
                .environmentObject(quotesStore)
            
            QuoteView()
                .environmentObject(quotesStore)
            
            FooterView()
            
            if !Util.isAdsRemovalPurchased() {
                GoogleAdBannerView()
            }
        }
        .edgesIgnoringSafeArea(Util.isAdsRemovalPurchased() ? .init() : .bottom)
        .onAppear {
            if !Util.isAdsRemovalPurchased() {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    DispatchQueue.main.async {
                        Util.loadGoogleInterstitialAd()
                    }
                })
            }
        }
        .background(
            ZStack {
                if appThemeImage != "" {
                    Image(appThemeImage)
                        .resizable()
                        .scaledToFill()
                }
            }
            .edgesIgnoringSafeArea(.all)
        )
    }
}

struct QuotesView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(QuotesStore())
            .environmentObject(InAppPurchaseHelper())
            .preferredColorScheme(.dark)
    }
}
