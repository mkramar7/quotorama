//
//  DismissSheetButtonView.swift
//  Quotorama
//
//  Created by Kramar Marko on 01.10.2024..
//

import SwiftUI

struct DismissSheetButtonView: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.down")
                .font(Util.appFont(25))
        }
    }
}
