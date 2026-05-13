//
//  AboutView.swift
//  Quotorama
//
//  Created by Marko Kramar on 15.03.2021..
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Support me".uppercased()).font(Util.appFont(15)).foregroundColor(.white)) {
                        ShareLink(item: "Hi! Check this app: https://\(Util.APP_STORE_APP_URL)") {
                            HStack {
                                Text("Share Quotorama")
                                    .font(Util.appFont(17))

                                Spacer()

                                Image(systemName: "square.and.arrow.up")
                                    .font(Util.appFont(25))
                            }
                            .padding()
                            .background(Color.gray.opacity(0.30))
                            .cornerRadius(10)
                        }

                        Link(destination: URL(string: "itms-apps://\(Util.APP_STORE_APP_URL)")!) {
                            HStack {
                                Text("Leave a review")
                                    .font(Util.appFont(17))

                                Spacer()

                                Image("review")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.30))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal, -10)
                .listStyle(SidebarListStyle())

                Text(Util.ATTRIBUTION_TEXT)
                    .multilineTextAlignment(.center)
                    .font(Util.appFont(11))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 15)
            }
            .navigationBarTitle("About")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    DismissSheetButtonView { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AboutView()
}
