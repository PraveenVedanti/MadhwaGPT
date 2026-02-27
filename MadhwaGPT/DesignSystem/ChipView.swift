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
    
    // Text inside the chip.
    let text: String
    
    let isSelected: Bool
    
    // Background color of the chip.
    let backgroundColor: Color
    
    // Font color of the text inside chip.
    let fontColor: Color
    
    // On tap of chip action.
    let onTap: () -> Void
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.light)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(width: 300, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(fontColor)
            )
            .shadow(color: fontColor, radius: 4, x: 0, y: 2)
            .onTapGesture {
                onTap()
            }
    }
}
