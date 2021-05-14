//
//  GoogleAdBannerView.swift
//  Quotorama
//
//  Created by Marko Kramar on 14.03.2020.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

private struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

private struct GoogleAdBannerRepresentable: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<GoogleAdBannerRepresentable>) -> GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeBanner)
        banner.adUnitID = Constants.GOOGLE_BANNER_AD_UNIT_ID
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        
        let request = GADRequest()
        request.scene = UIApplication.shared.windows.first?.windowScene
        
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            DispatchQueue.main.async {
                banner.load(request)
            }
        })
        
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: UIViewRepresentableContext<GoogleAdBannerRepresentable>) {
        
    }
}

struct GoogleAdBannerView: View {
    var body: some View {
        Group {
            if UIApplication.shared.windows.first!.safeAreaInsets.bottom > 0 {
                googleBannerWithBackground()
            } else {
                googleBanner()
            }
        }
    }
    
    func googleBanner() -> some View {
        GoogleAdBannerRepresentable()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
    }
    
    func googleBannerWithBackground() -> some View {
        VStack {
            googleBanner()
            VisualEffectView(effect: UIBlurEffect(style: .dark)).padding(0).edgesIgnoringSafeArea(.all)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: (50 + UIApplication.shared.windows.first!.safeAreaInsets.bottom))
        .padding(0)
    }
}
