//
//  ViewModifier.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/16/26.
//

import Foundation
import SwiftUI

struct CardBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    var backgroundColor: Color
    var textColor: Color
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(backgroundColor)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(textColor ,lineWidth: 0.25)
            }
            .shadow(color: textColor.opacity(0.05), radius: 8, y: 4)
    }
}

// Extension to make it easy to use
extension View {
    func cardBackgroundStyle(backroundColor: Color, textColor: Color) -> some View {
        self.modifier(CardBackgroundModifier(backgroundColor: backroundColor, textColor: textColor))
    }
}
