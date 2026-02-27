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
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(backgroundColor))
            )
            .shadow(
                color: colorScheme == .dark ? .white.opacity(0.06) : .black.opacity(0.12),
                radius: 20,
                x: 0,
                y: 8
            )
    }
}

// Extension to make it easy to use
extension View {
    func cardBackgroundStyle(backroundColor: Color, textColor: Color) -> some View {
        self.modifier(CardBackgroundModifier(backgroundColor: backroundColor, textColor: textColor))
    }
}
