//
//  QuoteView.swift
//  Quotorama
//
//  Created by Marko Kramar on 15.02.2021..
//

import SwiftUI

struct QuoteView: View {
    @EnvironmentObject var quotesStore: QuotesStore
    
    @Binding var currentQuote: Quote
    @State private var quoteShown = true
    
    var body: some View {
        if quoteShown {
            VStack {
                VStack(alignment: .leading) {
                    Text("„\(currentQuote.text)“")
                        .italic()
                        .font(Font.custom("Baskerville", size: 35))
                        .padding(.bottom, 10)
                        
                    HStack {
                        Spacer()
                        
                        Text(currentQuote.author)
                            .italic()
                            .font(Font.custom("Baskerville", size: 25))
                            .padding(.trailing, -5)
                    }
                    .onTapGesture {
                        guard let url = URL(string: "\(QuotoramaConstants.wikipediaBaseUrl)\(currentQuote.authorNameNormalized)") else { return }
                        UIApplication.shared.open(url)
                    }
                }
                .padding([.top, .bottom], 35)
                .padding(.leading, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 35)
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 35)
                
                Image(systemName: quotesStore.isFavorite(currentQuote) ? "heart.fill" : "heart")
                    .font(Font.system(size: 40))
                    .opacity(quotesStore.isFavorite(currentQuote) ? 1 : 0.3)
                    .onTapGesture {
                        quotesStore.toggleFavorite(currentQuote)
                    }
            }
            .transition(AnyTransition.asymmetric(insertion: AnyTransition.move(edge: .trailing), removal: AnyTransition.move(edge: .leading)))
            .animation(.default)
            .gesture(DragGesture().onEnded({ value in
                if value.translation.width < 0 {
                    quoteShown.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        currentQuote = quotesStore.nextQuote
                        quoteShown.toggle()
                    }
                }
            }))
            .padding(.bottom, 50)
        }
    }
}
