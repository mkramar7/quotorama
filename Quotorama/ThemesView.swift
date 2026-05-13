//
//  ThemesView.swift
//  Quotorama
//
//  Created by Marko Kramar on 15.03.2021..
//

import SwiftUI

struct ThemesView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("appThemeImage") var appThemeImage: String = ""

    var body: some View {
        NavigationStack {
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
                    DismissSheetButtonView { dismiss() }
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
            .accessibilityElement(children: .ignore)
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("\(prettyName(imagesPair.0)) theme")
            .accessibilityValue(appThemeImage == imagesPair.0 ? "Selected" : "")

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
            .accessibilityElement(children: .ignore)
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("\(prettyName(imagesPair.1)) theme")
            .accessibilityValue(appThemeImage == imagesPair.1 ? "Selected" : "")

            Spacer()
        }
        .padding(.bottom, 20)
    }

    private func prettyName(_ image: String) -> String {
        image.replacingOccurrences(of: "_", with: " ").capitalized
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

#Preview {
    ThemesView()
}
