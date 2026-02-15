//
//  ChatSuggestionCard.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/15/26.
//

import Foundation
import SwiftUI

struct ChatSuggestionCard: View {
    let text: String
    let onTap: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "sparkles")
                    .foregroundStyle(Color.orange)
                    .padding(.top, 2)
                
                Text(text)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(.ultraThinMaterial) // Adaptive blur
                    
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.orange.opacity(colorScheme == .dark ? 0.05 : 0.08))
                }
            )
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.orange.opacity(colorScheme == .dark ? 0.15 : 0.1), lineWidth: 0.5)
            }
            .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// Custom button style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
