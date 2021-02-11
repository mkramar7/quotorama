//
//  ContentView.swift
//  QuotoramaWatch Extension
//
//  Created by Marko Kramar on 11.02.2021..
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var quotesStore: QuotesStore
    @State var currentQuote: Quote
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(currentQuote.text)
                HStack {
                    Spacer()
                    
                    Text(currentQuote.author)
                        .font(.subheadline)
                        .italic()
                        .padding(.top, 10)
                }
                Spacer()
            }
            .background(Color.black)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .animation(.easeInOut(duration: 0.4))
            .gesture(DragGesture().onEnded({ value in
                if value.translation.width < 0 {
                    fetchNextQuote()
                }
            }))
            .onTapGesture(count: 2, perform: fetchNextQuote)
        }
    }
    
    func fetchNextQuote() {
        currentQuote = quotesStore.nextQuote
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(currentQuote: QuotesStore().nextQuote)
    }
}
