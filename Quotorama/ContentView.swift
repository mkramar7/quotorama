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
                QuotoramaButton(text: "Favorites", icon: "heart.fill") {
                    favoritesViewShown = true
                }
                .padding(.top, 20)
                .padding(.leading, 20)
                .sheet(isPresented: $favoritesViewShown) {
                    FavoritesView()
                        .preferredColorScheme(.dark)
                        .environmentObject(quotesStore)
                }
                
                Spacer()
                
                QuotoramaButton(text: "Share", icon: "square.and.arrow.up") {
                    let data = "„\(currentQuote.text)“ by \(currentQuote.author)"
                    let shareView = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                    UIApplication.shared.windows.first?.rootViewController?.present(shareView, animated: true, completion: nil)
                }
                .padding(.top, 20)
                .padding(.trailing, 20)
            }
            
            Spacer()
            
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

struct QuotoramaButton: View {
    var text: String
    var icon: String
    var action: () -> ()
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(Font.custom("Baskerville", size: 15))
                    .foregroundColor(.white)
                
                Text(text)
                    .foregroundColor(.white)
            }
            .padding(10)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(10)
            
        }
    }
}
