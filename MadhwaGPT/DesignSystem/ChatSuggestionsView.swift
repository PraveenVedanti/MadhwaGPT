//
//  ChatSuggestionsView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/13/26.
//

import Foundation
import SwiftUI

struct ChatSuggestionsView: View {
    
    let suggestion: String
    let onTap: () -> Void
    
    init(suggestion: String, onTap: @escaping () -> Void) {
        self.suggestion = suggestion
        self.onTap = onTap
    }
    
    var body: some View {
        HStack {
            Text(suggestion)
                .font(.system(.subheadline, design: .serif))
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .stroke(Color.secondary.opacity(0.7), lineWidth: 1)
                )
                .onTapGesture {
                    onTap()
                }
            
            Spacer()
        }
    }
}
