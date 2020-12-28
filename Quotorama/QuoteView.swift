//
//  QuoteView.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI

struct QuoteView: View {
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
                
                Image(systemName: currentQuote.isFavorite ? "heart.fill" : "heart")
                    .font(Font.system(size: 60))
                    .foregroundColor(currentQuote.isFavorite ? .red : .black)
                    .onTapGesture {
                        quotesStore.toggleFavorite($currentQuote)
                    }
            }
            .gesture(DragGesture().onEnded({ value in
                if value.translation.width < 0 {
                    loadNextQuote()
                }
            }))
            .layoutPriority(1)
        }
    }
    
    func loadNextQuote() {
        withAnimation(.spring()) {
            currentQuote = quotesStore.getNextQuote()
        }
    }
}
