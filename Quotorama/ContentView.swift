//
//  QuoteView.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var quotesStore: QuotesStore
    @State var currentQuote: Quote
    
    @State private var quoteShown = true
    @State private var favoritesViewShown = false;
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: {
                    favoritesViewShown = true
                }) {
                    Image(systemName: "person")
                        .font(.title)
                }
                .padding(.top, 20)
                .padding(.trailing, 20)
                .sheet(isPresented: $favoritesViewShown) {
                    FavoritesView()
                        .environmentObject(quotesStore)
                }
            }
            
            Spacer()
            
            if quoteShown {
                VStack {
                    VStack(alignment: .leading) {
                        Text("„\(currentQuote.text)“")
                            .italic()
                            .opacity(0.8)
                            .font(Font.custom("Baskerville", size: 35))
                            .padding(.bottom, 10)
                            
                        HStack {
                            Spacer()
                            
                            Text(currentQuote.author)
                                .italic()
                                .opacity(0.8)
                                .font(Font.custom("Baskerville", size: 25))
                                .padding(.trailing, -5)
                        }
                        .onTapGesture {
                            guard let url = URL(string: "\(QuotoramaConstants.wikipediaBaseUrl)\(currentQuote.authorForUrl)") else { return }
                            UIApplication.shared.open(url)
                        }
                    }
                    .padding(35)
                    
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
                            loadNextQuote()
                            quoteShown.toggle()
                        }
                    }
                }))
                .padding(.bottom, 50)
                
                Spacer()
            }
        }
    }
    
    func loadNextQuote() {
        currentQuote = quotesStore.nextQuote
    }
}

struct ContentView_Previews: PreviewProvider {
    static var quotesStore = QuotesStore()
    
    static var previews: some View {
        ContentView(currentQuote: quotesStore.nextQuote)
            .environmentObject(quotesStore)
    }
}
