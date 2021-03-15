//
//  QuotoramaButtonView.swift
//  Quotorama
//
//  Created by Marko Kramar on 15.02.2021..
//

import SwiftUI

struct ActionButtonView: View {
    var text: String
    var icon: String?
    var action: () -> ()
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.white)
                }
                
                Text(text)
                    .font(Util.appFont(15))
                    .foregroundColor(.white)
            }
            .padding(10)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(10)
            
        }
    }
}
