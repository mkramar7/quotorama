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
    static let SAMPLE_GOOGLE_INTERSTITIAL_AD_UNIT_ID = "ca-app-pub-3940256099942544/4411468910"
    static let REAL_GOOGLE_INTERSTITIAL_AD_UNIT_ID = "ca-app-pub-2246687869317180/5429182192"
    
    private static var interstitialAd: GADInterstitialAd!
    
    static func showGoogleInterstitialAd() {
        interstitialAd.present(fromRootViewController: (UIApplication.shared.windows.first?.rootViewController)!)
    }
    
    static func loadGoogleInterstitialAd() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: REAL_GOOGLE_INTERSTITIAL_AD_UNIT_ID, request: request) { [self] ad, error in
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
        guard let url = URL(string: "\(QuotoramaConstants.wikipediaBaseUrl)\(quote.authorNameNormalized)") else { return }
        UIApplication.shared.open(url)
    }
    
}
