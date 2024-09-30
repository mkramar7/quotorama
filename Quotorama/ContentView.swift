//
//  QuotesView.swift
//  Quotorama
//
//  Created by Marko Kramar on 08.03.2021..
//

import SwiftUI
import AppTrackingTransparency

struct ContentView: View {
    @EnvironmentObject var quotesStore: QuotesStore
    @AppStorage("appThemeImage") var appThemeImage: String = ""
    @State private var selectedQuote = ""
    
    var body: some View {
        VStack {
            HeaderView()
                .environmentObject(quotesStore)
            
            QuoteView(selectedQuote: $selectedQuote)
                .environmentObject(quotesStore)
            
            FooterView()
        }
        .onOpenURL { url in
            selectedQuote = url.absoluteString.components(separatedBy: "widget://quoteid=")[1]
        }
        .background(
            ZStack {
                if appThemeImage != "" {
                    Image(appThemeImage)
                        .resizable()
                        .scaledToFill()
                }
            }
            .ignoresSafeArea(.all)
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(QuotesStore())
        .preferredColorScheme(.dark)
}
