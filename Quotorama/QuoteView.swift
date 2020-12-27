//
//  QuoteView.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI

struct QuoteView: View {
    let quote: Quote
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(quote.text ?? "")
                .italic()
                .font(Font.custom("SavoyeLetPlain", size: 45))
                .padding(.bottom, 5)
                
            HStack {
                Spacer()
                
                Text(quote.author ?? "Unknown author")
                    .italic()
                    .font(Font.headline.uppercaseSmallCaps())
                    .foregroundColor(.secondary)
                    .padding(.trailing, -5)
            }
            .shadow(radius: 0)
            .onTapGesture {
                if let _ = quote.author {
                    guard let url = URL(string: "https://en.wikipedia.org/w/index.php?search=\(quote.authorForUrl)") else { return }
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(quote: Quote(author: "Abraham Lincoln", text: "Watch the little things; a small leak will sink a great ship."))
    }
}
