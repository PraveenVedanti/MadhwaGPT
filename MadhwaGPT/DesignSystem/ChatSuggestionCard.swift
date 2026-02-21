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
    let font: String
    let onTap: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "sparkles")
                    .foregroundStyle(Color.blue)
                    .padding(.top, 2)
                
                Text(text)
                    .font(.custom(font, size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill((colorScheme == .dark ? Color(.systemBackground) : Color(uiColor: .secondarySystemBackground)))
            )
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
