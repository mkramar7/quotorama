//
//  ContentView2.swift
//  Quotorama
//
//  Created by Marko Kramar on 08.03.2021..
//

import SwiftUI

struct ContentView2: View {
    @EnvironmentObject var quotesStore: QuotesStore
    
    var body: some View {
        //GeometryReader { geometry in
            ScrollView {
                LazyHStack {
                    /*TabView {
                        ForEach(quotesStore.quotes.prefix(5), id: \.self) { quote in
                            VStack {
                                Text(quote.text)
                                HStack {
                                    Spacer()

                                    Text(quote.author)
                                }
                            }
                            .padding(.horizontal, 20)
                            .frame(width: geometry.size.width)
                        }
                    }
                    frame(width: UIScreen.main.bounds.width, height: 200)
                    .tabViewStyle(PageTabViewStyle())*/
                    TabView {
                        ForEach(quotesStore.quotes.prefix(300), id: \.self) { quote in
                            ZStack {
                                Color.black
                                VStack {
                                    Text(quote.text)
                                    HStack {
                                        Spacer()

                                        Text(quote.author)
                                    }
                                }
                            }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        }
                        .padding(.all, 10)
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 200)
                    .tabViewStyle(PageTabViewStyle())
                }
            }
        //}
    }
}
