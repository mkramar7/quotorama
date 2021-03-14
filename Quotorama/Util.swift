//
//  QuotoramaUtil.swift
//  Quotorama
//
//  Created by Marko Kramar on 05.03.2021..
//

import Foundation
import SwiftUI
import GoogleMobileAds

class Util {
    private static var interstitialAd: GADInterstitialAd!
    
    static func showGoogleInterstitialAd() {
        interstitialAd.present(fromRootViewController: (UIApplication.shared.windows.first?.rootViewController)!)
    }
    
    static func loadGoogleInterstitialAd() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        let request = GADRequest()
        request.scene = UIApplication.shared.windows.first?.windowScene
        GADInterstitialAd.load(withAdUnitID: Constants.GOOGLE_INTERSTITIAL_AD_UNIT_ID, request: request) { [self] ad, error in
            if let error = error {
              print("Failed to load interstitial ad with error: \(error.localizedDescription)")
              return
            }

            interstitialAd = ad
        }
    }
    
    static func appFont(_ size: CGFloat) -> Font {
        Font.custom("Futura", size: size)
    }
    
    static func openAuthorWikipediaPage(_ quote: Quote) {
        guard let url = URL(string: "\(Constants.WIKIPEDIA_BASE_URL)\(quote.authorNameNormalized)") else { return }
        UIApplication.shared.open(url)
    }
    
}
