//
//  QuoteView.swift
//  Quotorama
//
//  Created by Marko Kramar on 16.03.2021..
//

import SwiftUI

struct QuoteView: View {
    @EnvironmentObject var quotesStore: QuotesStore
    @AppStorage("appThemeImage") var appThemeImage: String = ""
    
    @Binding var selectedQuoteIdFromWidget: String
    
    var body: some View {
        LazyHStack {
            TabView(selection: $selectedQuoteIdFromWidget) {
                ForEach(quotesStore.quotes) { quote in
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
                        }
                        .padding(.horizontal, 15)
                        .padding([.top, .bottom], 35)
                        .background(appThemeImage == "" ? Color.gray.opacity(0.3) : Color.black.opacity(0.7))
                        .cornerRadius(10)
                        
                        Group {
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
                                
                                ShareLink(item: "„\(quote.text)“ by \(quote.author)") {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundStyle(.white)
                                        .font(Font.system(size: 35))
                                        .opacity(0.3)
                                }
                            }
                        }
                        .padding(10)
                        .background(appThemeImage == "" ? Color.gray.opacity(0) : Color.black.opacity(0.7))
                        .cornerRadius(15)
                    }
                    .tag(quote.id)
                }
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 20)
            }
            .frame(width: UIScreen.main.bounds.width)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}
