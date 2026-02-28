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
            .padding(.bottom, 12)
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
                .frame(width: 24, height: 24)
                .foregroundStyle(fontColor.opacity(0.75))
        }
        .padding(.trailing, 8)
        .padding(.bottom, 12)
    }
}


struct TypewriterText: View {
    
    let fullText: AttributedString
    let typingSpeed: UInt64
    
    @State private var displayedText = AttributedString()
    @State private var typingTask: Task<Void, Never>?
    
    @State private var responseDisplayed = false
    
    var body: some View {
        Text(displayedText)
            .font(.system(size: 18, weight: .regular))
            .foregroundColor(.primary.opacity(0.6))
            .lineSpacing(6)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .onAppear {
                if !responseDisplayed {
                    startTyping()
                }
                responseDisplayed.toggle()
            }
            .onDisappear {
                typingTask?.cancel()
                responseDisplayed = true
            }
    }
    
    private func startTyping() {
        typingTask?.cancel()
        displayedText = AttributedString()
        
        typingTask = Task {
            await typeAttributedText()
        }
    }
    
    private func typeAttributedText() async {
        for run in fullText.runs {
            
            if Task.isCancelled { return }
            
            let runText = fullText[run.range]
            
            for character in runText.characters {
                
                if Task.isCancelled { return }
                
                var charAttributed = AttributedString(String(character))
                charAttributed.mergeAttributes(run.attributes)
                
                displayedText.append(charAttributed)
                
                try? await Task.sleep(nanoseconds: typingSpeed)
            }
        }
    }
}
