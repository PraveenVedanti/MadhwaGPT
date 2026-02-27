//
//  MarkdownMessageView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/4/26.
//

import Foundation
import SwiftUI

struct MarkdownMessageView: View {
    let content: String
    let isUserMessage: Bool
    
    var body: some View {
        // 1. Pre-clean the API string
        let cleaned = content.replacingOccurrences(of: "\\n", with: "\n")
        
        // 2. Use the most reliable parsing options
        let options = AttributedString.MarkdownParsingOptions(
            interpretedSyntax: .inlineOnlyPreservingWhitespace
        )
        
        if let attributed = try? AttributedString(markdown: cleaned, options: options) {
            
            if isUserMessage {
                Text(styleMarkdown(attributed))
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.primary.opacity(0.6))
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                let dynamicSpeed = styleMarkdown(attributed).characters.count < 50
                    ? 8_000_000
                    : 2_000_000
                
                TypewriterText(
                    fullText: styleMarkdown(attributed),
                    typingSpeed: UInt64(dynamicSpeed)
                )
            }
        } else {
            Text(cleaned)
        }
    }
    
    private func styleMarkdown(_ attributed: AttributedString) -> AttributedString {
        var styled = attributed
        
        // 1. Set base font and Paragraph Style
        styled.font = .system(size: 18, weight: .regular)
        styled.foregroundColor = .primary
        
        // Add spacing between paragraphs/bullets
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 6 // Space after each paragraph
        paragraphStyle.lineSpacing = 4      // Space between lines in the same paragraph
        
        // Apply this style to the whole container
        styled.mergeAttributes(AttributeContainer([.paragraphStyle: paragraphStyle]))
        
        for run in styled.runs {
            if let presentationIntent = run.presentationIntent {
                for intent in presentationIntent.components {
                    switch intent.kind {
                    case .header:
                        switch intent.identity {
                        case 1:
                            styled[run.range].font = .system(size: 26, weight: .bold)
                        case 2:
                            styled[run.range].font = .system(size: 22, weight: .bold)
                        case 3:
                            styled[run.range].font = .system(size: 20, weight: .bold)
                        default:
                            styled[run.range].font = .system(size: 18, weight: .bold)
                        }
                        
                    case .listItem:
                       
                        break
                    default:
                        break
                    }
                }
            }
            
            // 2. Handle Inline Elements (Bold/Italic)
            if let inlineIntent = run.inlinePresentationIntent {
                if inlineIntent.contains(.stronglyEmphasized) {
                    styled[run.range].font = .system(size: 16, weight: .bold)
                }
                
                if inlineIntent.contains(.emphasized) {
                    styled[run.range].font = .system(size: 16).italic()
                }
            }
        }
        styled.inlinePresentationIntent = []
        return styled
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct ChatBubbleView: View {
    let message: ChatMessage
    @State var textColor: Color
    
    var body: some View {
        HStack {
            
            if message.isUser { Spacer(minLength: 20) }
            
            VStack(alignment: .leading, spacing: 0) {
                MarkdownMessageView(content: message.text, isUserMessage: message.isUser)
            }
            .padding(12)
            .background(message.isUser ? textColor.opacity(0.2) : Color.clear)
            .foregroundColor(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(
                maxWidth: UIScreen.main.bounds.width,
                alignment: message.isUser ? .trailing : .leading
            )
            
            if !message.isUser { Spacer(minLength: 20) }
        }
        .padding(.vertical, 4)
    }
}

