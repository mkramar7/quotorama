//
//  QuoteView.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI

struct QuoteView: View {
    @AppStorage("favoriteQuotes") var favoriteQuotes: [String]  = []
    
    @EnvironmentObject var quotesStore: QuotesStore
    @State var currentQuote: Quote
    
    var body: some View {
        ZStack {
            Image("background")
            
            VStack {
                VStack(alignment: .leading) {
                    Text("„\(currentQuote.text)“")
                        .italic()
                        .font(Font.custom("SavoyeLetPlain", size: 45))
                        .padding(.bottom, 5)
                        
                    HStack {
                        Spacer()
                        
                        Text(currentQuote.author)
                            .italic()
                            .font(Font.headline.uppercaseSmallCaps())
                            .foregroundColor(.secondary)
                            .padding(.trailing, -5)
                    }
                    .shadow(radius: 0)
                    .onTapGesture {
                        guard let url = URL(string: "\(QuotoramaConstants.wikipediaBaseUrl)\(currentQuote.authorForUrl)") else { return }
                        UIApplication.shared.open(url)
                    }
                }
                .padding(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.black, lineWidth: 1)
                )
                .background(RoundedRectangle(cornerRadius: 40).fill(QuotoramaConstants.yellowishColor))
                .padding(10)
                
                Image("favorite")
                    .font(Font.system(size: 60))
                    .opacity(quotesStore.isFavorite(currentQuote) ? 1 : 0.3)
                    .scaleEffect(quotesStore.isFavorite(currentQuote) ? 1.5 : 1)
                    .animation(.easeInOut(duration: 0.2))
                    .onTapGesture {
                        quotesStore.makeFavorite(currentQuote)
                    }
            }
            .layoutPriority(1)
            .gesture(DragGesture().onEnded({ value in
                if value.translation.width < 0 {
                    loadNextQuote()
                }
            }))
        }
    }
    
    func loadNextQuote() {
        withAnimation(.spring()) {
            currentQuote = quotesStore.getNextQuote()
        }
    }
}
