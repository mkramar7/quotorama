//
//  ContentView.swift
//  Quotorama
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI

struct ContentView: View {
    @State private var currentQuote = QuotesStore.getNextQuote()
    var body: some View {
        Group {
            ZStack {
                Image("background")
                    
                QuoteView(quote: currentQuote)
                    .padding(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .background(RoundedRectangle(cornerRadius: 40).fill(quotePopupColor()))
                    .padding(10)
                    .layoutPriority(1)
                    //.shadow(color: .black, radius: 5, x: 8, y: 8)
                }
                .onTapGesture(count: 2) {
                    withAnimation(.spring()) {
                        currentQuote = QuotesStore.getNextQuote()
                    }
                }
        }
    }
    
    func quotePopupColor() -> Color {
        Color(red: 246 / 255, green: 216 / 255, blue: 135 / 255)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
