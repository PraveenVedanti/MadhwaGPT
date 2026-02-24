//
//  ExpandingTextView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/18/26.
//

import Foundation
import SwiftUI

struct ExpandingTextInput: View {
    
    // Binding variable for text field input.
    @Binding var text: String
    
    // Binding variable to show/dismiss keyboard.
    @FocusState.Binding var isFocused: Bool
    
    // Back ground color
    let backgroundColor: Color
    
    // Font color
    let fontColor: Color
    
    // On tap of send button action.
    let onTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            textFieldView
            
            sendButton
        }
        .padding()
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: text)
    }
    
    private var textFieldView: some View {
        TextField(MGPTStrings.ChatTab.textEditorPlaceHolder, text: $text, axis: .vertical)
            .padding(.vertical, 8)
            .padding(.leading, 12)
            .padding(.trailing, 48)
            .padding(.bottom, 32)
            .lineLimit(1...6)
            .focused($isFocused)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.primary.opacity(0.5), lineWidth: 0.5)
            )
    }
    
    private var sendButton: some View {
        Button {
            onTap()
            isFocused = false
        } label: {
            Image(systemName: "arrow.up.circle.fill")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundStyle(fontColor.opacity(0.75))
        }
        .padding(.trailing, 8)
        .padding(.bottom, 8)
    }
}
