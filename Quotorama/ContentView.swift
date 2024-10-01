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
    @State private var selectedQuoteIdFromWidget = ""
    
    var body: some View {
        VStack {
            HeaderView()
                .environmentObject(quotesStore)
            
            QuoteView(selectedQuoteIdFromWidget: $selectedQuoteIdFromWidget)
                .environmentObject(quotesStore)
            
            FooterView()
        }
        .onOpenURL { url in
            selectedQuoteIdFromWidget = url.absoluteString.components(separatedBy: "widget://quoteid=")[1]
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
