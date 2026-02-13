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
            .padding(.horizontal, 16)
            .frame(height: height)
            .background(
                Capsule()
                    .fill(isSelected ? Color.orange.opacity(0.7) : Color.clear)
            )
            .overlay(
                Capsule()
                    .stroke(Color.orange.opacity(0.7), lineWidth: 1)
            )
            .onTapGesture {
                onTap()
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}
