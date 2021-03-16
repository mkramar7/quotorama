//
//  SettingsView.swift
//  Quotorama
//
//  Created by Marko Kramar on 15.03.2021..
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var iapHelper: InAppPurchaseHelper
    @Environment(\.presentationMode) var presentationMode
    
    @State private var shareAppViewShown = false
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Futura", size: 30)!]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Premium Content".uppercased()).font(Util.appFont(15)).foregroundColor(.white)) {
                        ForEach(iapHelper.allInAppPurchases, id: \.self) { inAppPurchase in
                            InAppPurchaseRowView(inAppPurchase: inAppPurchase)
                                .environmentObject(iapHelper)
                        }
                        
                        HStack {
                            Spacer()
                            
                            ActionButtonView(text: "Restore purchases", icon: "purchased") {
                                restorePurchases()
                            }
                            .font(Util.appFont(30))
                            
                            Spacer()
                        }
                    }
                    
                    Section(header: Text("Support us".uppercased()).font(Util.appFont(15)).foregroundColor(.white)) {
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
                        .onTapGesture {
                            shareAppViewShown.toggle()
                        }
                        .sheet(isPresented: $shareAppViewShown) {
                            ShareSheetView(activityItems: ["Hi! Check this app: https://\(Constants.APP_STORE_APP_URL)"])
                        }
                        
                        HStack {
                            Text("Leave us a Review")
                                .font(Util.appFont(17))
                            
                            Spacer()
                            
                            Image("review")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.30))
                        .cornerRadius(10)
                        .onTapGesture {
                            if let url = URL(string: "itms-apps://\(Constants.APP_STORE_APP_URL)") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
                .padding(.horizontal, -10)
                .listStyle(SidebarListStyle())
                
                    Text("\"Art of Silence - by Uniq\" is under a Creative Commons license (Creative Commons – International Recognition 4.0 – CC BY 4.0)")
                        .multilineTextAlignment(.center)
                        .font(Util.appFont(11))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 15)
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                DismissSheetButtonView()
            })
        }
        .preferredColorScheme(.dark)
    }
    
    func restorePurchases() {
        iapHelper.restorePurchases()
    }
}

struct InAppPurchaseRowView: View {
    let inAppPurchase: InAppPurchase
    @EnvironmentObject var iapHelper: InAppPurchaseHelper
    
    var body: some View {
        HStack {
            Text(inAppPurchase.title)
                .font(Util.appFont(17))
            
            Spacer()
            
            if let price = inAppPurchase.price, inAppPurchase.isLocked {
                ActionButtonView(text: price, icon: "dollarsign.circle") {
                    if inAppPurchase.isLocked {
                        if let product = iapHelper.product(for: inAppPurchase.id) {
                            iapHelper.purchaseProduct(product)
                        }
                    }
                }
                .background(Color.green.opacity(0.2))
                .cornerRadius(10)
            } else {
                Text("PURCHASED")
                    .bold()
                    .padding(10)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
            }
            
        }
        .padding()
        .background(Color.gray.opacity(0.30))
        .cornerRadius(10)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(InAppPurchaseHelper())
    }
}
