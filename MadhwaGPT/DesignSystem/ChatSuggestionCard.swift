//
//  ChatSuggestionCard.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/15/26.
//

import Foundation
import SwiftUI

struct SuggestionCard: View {
    let question: String
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(question)
                .font(.body)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .onTapGesture {
            onTap()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .frame(width: 300)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.primary.opacity(0.5), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }
}
