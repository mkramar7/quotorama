//
//  QuoteView.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI
import URLImage

struct QuoteView: View {
    @EnvironmentObject var quotesStore: QuotesStore
    @State var currentQuote: Quote
    
    @State var authorImageShown = false
    @State var authorImageUrl = ""
    
    var body: some View {
        ZStack {
            Image("background")
            
            VStack {
                if (authorImageShown && authorImageUrl != "") {
                    URLImage(url: URL(string: authorImageUrl)!) { image in
                        image
                            .cornerRadius(20)
                    }
                }
                
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
                        quotesStore.toggleFavorite(currentQuote)
                    }
            }
            .onAppear(perform: loadAuthorImage)
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
            currentQuote = quotesStore.nextQuote
            loadAuthorImage()
        }
    }
    
    func loadAuthorImage() {
        let url = URL(string: "\(QuotoramaConstants.wikipediaQuoteAuthorImageBaseUrl)\(currentQuote.authorForUrl)")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                if let quoteAuthorImageData = data {
                    let decodedImageData = try JSONDecoder().decode(WikipediaImageResult.self, from: quoteAuthorImageData)
                    DispatchQueue.main.async {
                        authorImageUrl = decodedImageData.query.pages[0].thumbnail.source
                        authorImageShown = true
                    }
                } else {
                    print("No image data for this author")
                    authorImageUrl = ""
                    authorImageShown = false
                }
            } catch {
                authorImageUrl = ""
                authorImageShown = false
            }
        }.resume()
    }
}
