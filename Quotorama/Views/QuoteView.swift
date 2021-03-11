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
    @State private var interstitialCounter = 0
    
    var body: some View {
        if quoteShown {
            VStack {
                VStack(alignment: .leading) {
                    Text("„\(currentQuote.text)“")
                        .font(Util.appFont(20))
                        .padding(.bottom, 10)
                        
                    HStack {
                        Spacer()
                        
                        Text(currentQuote.author)
                            .foregroundColor(.secondary)
                            .font(Util.appFont(15))
                            .padding(.trailing, -5)
                    }
                    .onTapGesture {
                        guard let url = URL(string: "\(QuotoramaConstants.wikipediaBaseUrl)\(currentQuote.authorNameNormalized)") else { return }
                        UIApplication.shared.open(url)
                    }
                }
                .padding(.horizontal, 15)
                .padding([.top, .bottom], 35)
                .background(Color.gray.opacity(0.30))
                .cornerRadius(10)
                
                Image(systemName: quotesStore.isFavorite(currentQuote) ? "heart.fill" : "heart")
                    .font(Font.system(size: 40))
                    .opacity(quotesStore.isFavorite(currentQuote) ? 1 : 0.3)
                    .onTapGesture {
                        quotesStore.toggleFavorite(currentQuote)
                    }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .transition(AnyTransition.asymmetric(insertion: AnyTransition.move(edge: .trailing), removal: AnyTransition.move(edge: .leading)))
            .animation(.default)
            .padding(.bottom, 50)
            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 10)
            .contentShape(Rectangle())
            .gesture(DragGesture().onEnded({ value in
                if value.translation.width < 0 {
                    quoteShown.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        currentQuote = quotesStore.nextQuote
                        quoteShown.toggle()
                        
                        interstitialCounter += 1
                        if (interstitialCounter == 8) {
                            Util.showGoogleInterstitialAd()
                            interstitialCounter = 0
                        }
                    }
                }
            }))
        }
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(currentQuote: .constant(QuotesStore().nextQuote))
            .environmentObject(QuotesStore())
            .preferredColorScheme(.light)
    }
}

