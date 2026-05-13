//
//  QuotesView.swift
//  Quotorama
//
//  Created by Marko Kramar on 08.03.2021..
//

import SwiftUI

struct ContentView: View {
    @AppStorage("appThemeImage") var appThemeImage: String = ""
    @State private var selectedQuoteIdFromWidget = ""

    var body: some View {
        VStack {
            HeaderView()

            QuoteView(selectedQuoteIdFromWidget: $selectedQuoteIdFromWidget)

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
        .environment(QuotesStore())
        .preferredColorScheme(.dark)
}
