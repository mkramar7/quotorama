//
//  ContentView2.swift
//  Quotorama
//
//  Created by Marko Kramar on 08.03.2021..
//

import SwiftUI

struct ContentView2: View {
    @EnvironmentObject var quotesStore: QuotesStore
    
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
                        //ShareSheetView(activityItems: ["„\(quote.text)“ by \(currentQuote.author)"])
                    }
            }
            
            Spacer()
            
            ScrollView {
                LazyHStack {
                    TabView {
                        ForEach(quotesStore.quotes.prefix(300), id: \.self) { quote in
                            ZStack {
                                Color.black
                                VStack {
                                    VStack {
                                        VStack {
                                            VStack(alignment: .leading) {
                                                Text("„\(quote.text)“")
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
                                                    guard let url = URL(string: "\(QuotoramaConstants.wikipediaBaseUrl)\(quote.authorNameNormalized)") else { return }
                                                    UIApplication.shared.open(url)
                                                }
                                            }
                                            .padding(.horizontal, 15)
                                            .padding([.top, .bottom], 35)
                                            .background(Color.gray.opacity(0.30))
                                            .cornerRadius(10)
                                            
                                            Image(systemName: quotesStore.isFavorite(quote) ? "heart.fill" : "heart")
                                                .font(Font.system(size: 40))
                                                .opacity(quotesStore.isFavorite(quote) ? 1 : 0.3)
                                                .onTapGesture {
                                                    quotesStore.toggleFavorite(quote)
                                                }
                                        }
                                    }
                                }
                            }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        }
                        .padding(.all, 10)
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 300)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
            .background(Color.red)
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
            .environmentObject(QuotesStore())
            .preferredColorScheme(.dark)
    }
}
