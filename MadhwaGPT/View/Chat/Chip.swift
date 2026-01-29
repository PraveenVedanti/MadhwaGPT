//
//  Chip.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/28/26.
//

import Foundation
import SwiftUI

public struct Chip: View {
    
    private let title: String
    private let imageName: String?
    private let isSelected: Bool
    private let onTap: () -> Void
    
    public init(
        title: String,
        imageName: String? = nil,
        isSelected: Bool,
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.imageName = imageName
        self.isSelected = isSelected
        self.onTap = onTap
    }
    
    public var body: some View {
        HStack(spacing: 8.0) {
            if let imageName {
                Image(systemName: imageName)
            }
            
            Text(title)
                .font(Font.subheadline)
                .fontWeight(.regular)
        }
        .onTapGesture {
            onTap()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16.0)
                .stroke(Color.gray, lineWidth: 1)
                .fill(isSelected ? Color.orange.opacity(0.25) : Color.clear)
        )
    }
}
