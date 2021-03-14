//
//  ContentView2.swift
//  Quotorama
//
//  Created by Marko Kramar on 08.03.2021..
//

import SwiftUI

struct QuotesView: View {
    @EnvironmentObject var quotesStore: QuotesStore
    
    @State private var favoritesViewShown = false
    @State private var shareSheetViewShown = false
    
    var body: some View {
        VStack {
            HStack {
                ActionButtonView(text: "Favorites", icon: "hand.thumbsup.fill", action: { favoritesViewShown.toggle() })
                    .padding([.top, .leading], 20)
                    .sheet(isPresented: $favoritesViewShown, onDismiss: showAdOnRandom) {
                        FavoritesView().environmentObject(quotesStore)
                    }
                
                Spacer()
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
                                    .font(Font.system(size: 40))
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
                                    .font(Font.system(size: 40))
                                    .opacity(0.3)
                                    .onTapGesture { shareSheetViewShown.toggle() }
                                    .sheet(isPresented: $shareSheetViewShown) {
                                        ShareSheetView(activityItems: ["„\(quote.text)“ by \(quote.author)"])
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 10)
                }
                .frame(width: UIScreen.main.bounds.width)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .onAppear {
            Util.loadGoogleInterstitialAd()
            quotesStore.quotes.shuffle()
        }
    }
    
    func showAdOnRandom() {
        if Int.random(in: 1...5) == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Util.showGoogleInterstitialAd()
            }
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        QuotesView()
            .environmentObject(QuotesStore())
            .preferredColorScheme(.dark)
    }
}
