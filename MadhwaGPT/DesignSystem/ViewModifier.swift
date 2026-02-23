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
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.orange.opacity(colorScheme == .dark ? 0.05 : 0.08))
                }
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(
                        Color.orange.opacity(colorScheme == .dark ? 0.15 : 0.1),
                        lineWidth: 1
                    )
            }
            .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }
}

// Extension to make it easy to use
extension View {
    func cardBackgroundStyle() -> some View {
        self.modifier(CardBackgroundModifier())
    }
}
