//
//  QuotesView.swift
//  Quotorama
//
//  Created by Marko Kramar on 08.03.2021..
//

import SwiftUI

struct QuotesView: View {
    @EnvironmentObject var iapHelper: InAppPurchaseHelper
    @EnvironmentObject var quotesStore: QuotesStore
    
    @State private var favoritesViewShown = false
    @State private var shareSheetViewShown = false
    @State private var settingsViewShown = false
    
    @State private var musicIsPlaying = false
    
    var body: some View {
        VStack {
            HStack {
                ActionButtonView(text: "Favorites", icon: "hand.thumbsup.fill", action: { favoritesViewShown.toggle() })
                    .padding([.top, .leading], 20)
                    .sheet(isPresented: $favoritesViewShown, onDismiss: showAdOnRandom) {
                        FavoritesView().environmentObject(quotesStore)
                    }
                
                Spacer()
                
                ActionButtonView(text: "Settings", icon: "gearshape", action: { settingsViewShown.toggle() })
                    .padding([.top, .trailing], 20)
                    .sheet(isPresented: $settingsViewShown) {
                        SettingsView().environmentObject(iapHelper)
                    }
            }
            
            LazyHStack {
                TabView {
                    ForEach(quotesStore.quotes.prefix(500), id: \.self) { quote in
                        VStack {
                            VStack(alignment: .leading) {
                                Text("\(quote.text)")
                                    .font(Util.appFont(20))
                                    .padding(.bottom, 10)
                                    
                                HStack {
                                    Spacer()
                                    
                                    Text(quote.author)
                                        .italic()
                                        .foregroundColor(.secondary)
                                        .font(Util.appFont(15))
                                        .padding(.trailing, -5)
                                }
                                .onTapGesture {
                                    Util.openAuthorWikipediaPage(quote)
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding([.top, .bottom], 35)
                            .background(Color.gray.opacity(0.30))
                            .cornerRadius(10)
                            
                            HStack {
                                Image(systemName: "hand.thumbsup.fill")
                                    .font(Font.system(size: 35))
                                    .opacity(quotesStore.isFavorite(quote) ? 1 : 0.3)
                                    .onTapGesture {
                                        quotesStore.toggleFavorite(quote)
                                    }
                                
                                Divider()
                                    .background(Color.white)
                                    .opacity(1)
                                    .frame(height: 50)
                                    .padding(.horizontal, 20)
                                
                                Image(systemName: "square.and.arrow.up")
                                    .font(Font.system(size: 35))
                                    .opacity(0.3)
                                    .onTapGesture { shareSheetViewShown.toggle() }
                                    .sheet(isPresented: $shareSheetViewShown) {
                                        ShareSheetView(activityItems: ["„\(quote.text)“ by \(quote.author)"])
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 20)
                }
                .frame(width: UIScreen.main.bounds.width)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            
            HStack {
                ActionButtonView(text: musicIsPlaying ? "Stop playing" : "Ambient music", icon: musicIsPlaying ? "play" : "music.note", action: toggleMusic)
                    .padding([.bottom, .leading], 20)
                
                Spacer()
            }
            
            if !Util.isAdsRemovalPurchased() {
                GoogleAdBannerView()
            }
        }
        .edgesIgnoringSafeArea(Util.isAdsRemovalPurchased() ? .init() : .bottom)
        .onAppear {
            if !Util.isAdsRemovalPurchased() {
                Util.loadGoogleInterstitialAd()
            }
            
            quotesStore.quotes.shuffle()
        }
    }
    
    func toggleMusic() {
        if musicIsPlaying {
            MusicPlayer.shared.stop()
            musicIsPlaying = false
        } else {
            MusicPlayer.shared.play()
            musicIsPlaying = true
        }
    }
    
    func showAdOnRandom() {
        if !Util.isAdsRemovalPurchased() {
            if Int.random(in: 1...5) == 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Util.showGoogleInterstitialAd()
                }
            }
        }
    }
}

struct QuotesView_Previews: PreviewProvider {
    static var previews: some View {
        QuotesView()
            .environmentObject(QuotesStore())
            .preferredColorScheme(.dark)
    }
}

struct DismissSheetButtonView: View {
    var body: some View {
        Image(systemName: "chevron.down.circle")
            .font(Util.appFont(30))
            .padding(.all, 10)
            .foregroundColor(Color.white.opacity(0.5))
            .cornerRadius(10)
            .padding(.top, 10)
    }
}
