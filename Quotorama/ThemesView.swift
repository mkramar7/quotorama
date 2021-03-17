//
//  SettingsView.swift
//  Quotorama
//
//  Created by Marko Kramar on 15.03.2021..
//

import SwiftUI

struct ThemesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Futura", size: 30)!]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(Constants.THEMES, id: \.0) { themePair in
                    ThemeRowView(imagesPair: (themePair.0, themePair.1))
                }
                
                Spacer()
            }
            .padding(.top, 10)
            .navigationBarTitle("Themes")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    DismissSheetButtonView(action: { presentationMode.wrappedValue.dismiss() })
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ThemeRowView: View {
    let imagesPair: (String, String)
    
    var body: some View {
        HStack {
            Spacer()
            
            Image(imagesPair.0)
                .resizable()
                .scaledToFit()
                .cornerRadius(15)
                .frame(width: 150)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.5))
                )
                
            
            Spacer()
            
            Image(imagesPair.1)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .frame(width: 150)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.5))
                )
                
            Spacer()
        }
        .padding(.bottom, 20)
    }
}

struct ThemesView_Previews: PreviewProvider {
    static var previews: some View {
        ThemesView()
    }
}
