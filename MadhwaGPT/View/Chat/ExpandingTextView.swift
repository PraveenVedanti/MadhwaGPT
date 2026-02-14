//
//  ExpandingTextView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/18/26.
//

import Foundation
import SwiftUI

struct ExpandingTextInput: View {
    @Binding var text: String
    let placeholder =  "Ask about Madhvacharya's philosophy.."
    let minHeight: CGFloat = 52
    let maxHeight: CGFloat = 150

    @State private var textHeight: CGFloat = 48
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topLeading) {
                
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 6)
                    .frame(height: min(textHeight, maxHeight))
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            // Adaptive: White in Light, Elegant Charcoal in Dark
                            .fill(Color(.secondarySystemGroupedBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            // Adaptive: Subtle hairline that only "pops" in Dark Mode
                            .stroke(Color.primary.opacity(0.6), lineWidth: 0.5)
                    )
                    .cornerRadius(24)
                    .onChange(of: text, { oldValue, newValue in
                        recalculateHeight()
                    })
                
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color(.placeholderText))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
            }
        }
        .animation(.easeInOut, value: textHeight)
    }

    private func recalculateHeight() {
        let size = CGSize(width: UIScreen.main.bounds.width - 60, height: .infinity)
        let estimatedHeight = text.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 17)],
            context: nil
        ).height + 24

        textHeight = max(minHeight, estimatedHeight)
    }
}

