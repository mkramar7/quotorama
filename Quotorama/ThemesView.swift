//
//  ThemesView.swift
//  Quotorama
//
//  Created by Marko Kramar on 15.03.2021..
//

import SwiftUI

struct ThemesView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("appThemeImage") var appThemeImage: String = ""
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Futura", size: 30)!]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(Util.THEMES, id: \.0) { themePair in
                    ThemeRowView(imagesPair: (themePair.0, themePair.1))
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    ActionButtonView(text: "Restore default", icon: "arrow.uturn.backward", fontSize: 15) {
                        appThemeImage = ""
                    }
                    .padding(.bottom, 20)
                    
                    Spacer()
                }

            }
            .padding(.top, 10)
            .navigationBarTitle("Choose theme")
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
    @AppStorage("appThemeImage") var appThemeImage: String = ""
    
    let imagesPair: (String, String)
    
    var body: some View {
        HStack {
            Spacer()
            
            ThemeImageView(image: imagesPair.0).onTapGesture {
                appThemeImage = imagesPair.0
            }
            .opacity(appThemeImage == imagesPair.0 ? 1 : 0.8)
            .overlay(
                Group {
                    if appThemeImage == imagesPair.0 {
                        Image(systemName: "checkmark")
                            .font(Util.appFont(25))
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(15)
                    }
                }
            )
                
            Spacer()
            
            ThemeImageView(image: imagesPair.1).onTapGesture {
                appThemeImage = imagesPair.1
            }
            .opacity(appThemeImage == imagesPair.1 ? 1 : 0.8)
            .overlay(
                Group {
                    if appThemeImage == imagesPair.1 {
                        Image(systemName: "checkmark")
                            .font(Util.appFont(25))
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(15)
                    }
                }
            )
                
            Spacer()
        }
        .padding(.bottom, 20)
    }
}

struct ThemeImageView: View {
    let image: String
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
            .frame(width: 150)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.5))
            )
    }
}

struct ThemesView_Previews: PreviewProvider {
    static var previews: some View {
        ThemesView()
    }
}
