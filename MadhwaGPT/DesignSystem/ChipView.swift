//
//  ChipView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/12/26.
//

import Foundation
import SwiftUI

// MARK: - Chip View
struct Chip: View {
    
    let title: String
    let isSelected: Bool
    var height: CGFloat = 36
    let onTap: () -> Void
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.regular)
            .foregroundColor(isSelected ? .white : .primary)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .frame(minHeight: 48)
            .frame(width: 320)
            .background(
                Capsule()
                    .fill(isSelected ? Color.blue : Color.secondary.opacity(0.1))
            )
            .onTapGesture {
                onTap()
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}
