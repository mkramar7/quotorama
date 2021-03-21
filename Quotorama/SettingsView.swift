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
    @EnvironmentObject var quotesStore: QuotesStore
    
    @AppStorage("remindersEnabled") var remindersEnabled = false
    @AppStorage("reminderTime") private var reminderTime = Calendar.current.date(from: Util.dateComponentsForDefaultReminderTime())!
    
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
                    
                    Section(header: Text("Reminders".uppercased()).font(Util.appFont(15)).foregroundColor(.white)) {
                        
                        VStack {
                            HStack {
                                Text("Enable reminders")
                                    .font(Util.appFont(17))
                                
                                Spacer()
                                
                                Toggle("", isOn: $remindersEnabled)
                                    .onChange(of: remindersEnabled) { shouldEnableReminders in
                                        if shouldEnableReminders {
                                            askForNotifications()
                                        } else {
                                            disableNotifications()
                                        }
                                    }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.30))
                            .cornerRadius(10)
                            
                            if remindersEnabled {
                                HStack {
                                    Text("Show quote of the day at")
                                        .font(Util.appFont(17))
                                    
                                    Spacer()
                                    
                                    DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .onChange(of: reminderTime) { timeValue in
                                            enableNotifications()
                                        }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.30))
                                .cornerRadius(10)
                            }
                        }
                    }
                    
                    Section(header: Text("Support me".uppercased()).font(Util.appFont(15)).foregroundColor(.white)) {
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
                        .onTapGesture {
                            if let url = URL(string: "itms-apps://\(Constants.APP_STORE_APP_URL)") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
                .padding(.horizontal, -10)
                .listStyle(SidebarListStyle())
                
                Text(Constants.ATTRIBUTION_TEXT)
                    .multilineTextAlignment(.center)
                    .font(Util.appFont(11))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 15)
            }
            .navigationBarTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    DismissSheetButtonView(action: { presentationMode.wrappedValue.dismiss() })
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    func askForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                enableNotifications()
            } else {
                self.remindersEnabled = false
                disableNotifications()
            }
        }
    }
    
    func disableNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func enableNotifications() {
        print("enabling notifications")
        guard remindersEnabled else {
            print("Couldn't enable notifications...")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Quote of the day"
        let quote = quotesStore.nextQuote
        content.body = "\"\(quote.text)\" by \(quote.author)"
        
        var dateComponents = DateComponents()
        dateComponents.hour = Calendar.current.component(.hour, from: reminderTime)
        dateComponents.minute = Calendar.current.component(.minute, from: reminderTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print("Couldn't enable notifications...")
            }
        }
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
            .environmentObject(QuotesStore())
    }
}
