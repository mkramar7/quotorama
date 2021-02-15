//
//  QuotoramaButtonView.swift
//  Quotorama
//
//  Created by Marko Kramar on 15.02.2021..
//

import SwiftUI

struct QuotoramaButtonView: View {
    var text: String
    var icon: String
    var action: () -> ()
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(Font.custom("Baskerville", size: 15))
                    .foregroundColor(.white)
                
                Text(text)
                    .foregroundColor(.white)
            }
            .padding(10)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(10)
            
        }
    }
}
