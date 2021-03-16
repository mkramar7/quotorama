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
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Futura", size: 30)!]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(iapHelper.allInAppPurchases, id: \.self) { inAppPurchase in
                    InAppPurchaseRowView(inAppPurchase: inAppPurchase)
                        .environmentObject(iapHelper)
                }
                .padding(.horizontal, -10)
                .listStyle(SidebarListStyle())
                .font(Util.appFont(20))
                
                ActionButtonView(text: "Restore purchases", icon: "purchased") {
                    restorePurchases()
                }
                .font(Util.appFont(30))
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
    }
}
