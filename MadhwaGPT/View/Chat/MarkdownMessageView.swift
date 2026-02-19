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
    
    var body: some View {
        // 1. Pre-clean the API string
        let cleaned = content.replacingOccurrences(of: "\\n", with: "\n")
        
        // 2. Use the most reliable parsing options
        let options = AttributedString.MarkdownParsingOptions(
            interpretedSyntax: .inlineOnlyPreservingWhitespace
        )
        
        if let attributed = try? AttributedString(markdown: cleaned, options: options) {
            
            Text(styleMarkdown(attributed))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(6)
        } else {
            Text(cleaned)
        }
    }
    
    private func styleMarkdown(_ attributed: AttributedString) -> AttributedString {
        var styled = attributed
        
        // 1. Set base font and Paragraph Style
        styled.font = .system(size: 16, weight: .regular)
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
        
       
        // 3. Handle Citations (e.g., [1], [23])
        let textString = String(styled.characters)
        
        if let regex = try? NSRegularExpression(pattern: "\\[\\d+\\]", options: []) {
            let matches = regex.matches(in: textString, options: [], range: NSRange(location: 0, length: textString.count))
            
            for match in matches {
                if let range = Range(match.range, in: styled) {
                    styled[range].foregroundColor = .orange
                    styled[range].font = .system(size: 18, weight: .bold)
                    styled[range].baselineOffset = 4
                }
            }
        }
        
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
    
    var body: some View {
        HStack {
            
            if message.isUser { Spacer(minLength: 20) }
            
            VStack(alignment: .leading, spacing: 0) {
                MarkdownMessageView(content: message.text)
            }
            .padding(12)
            .background(message.isUser ? Color.gray.opacity(0.2) : Color("SaffronCardBackround"))
            .foregroundColor(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(
                maxWidth: UIScreen.main.bounds.width,
                alignment: message.isUser ? .trailing : .leading
            )
            
            if !message.isUser { Spacer(minLength: 20) }
        }
        .padding(.vertical, 4)
        .padding(.horizontal)
    }
}

