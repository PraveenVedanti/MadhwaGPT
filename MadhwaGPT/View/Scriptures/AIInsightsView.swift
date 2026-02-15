//
//  AIInsightsView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/14/26.
//

import Foundation
import SwiftUI

struct AIInsightsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let verse: ScriptureChapterVerse
    
    @State private var messages: [ChatMessage] = []
    
    // Use a state variable to track loading
    @State private var isSending = false
    
    // State variable for show settings view.
    @State private var shouldShowSettings = false
    
    // State variable to show/hide initial suggestions.
    @State private var shouldHideInitialSuggestions = false
    
    @State private var message = ""
    
    init(verse: ScriptureChapterVerse) {
        self.verse = verse
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                chatScrollView
                
                if isSending {
                    typingIndicator
                }
                
                textEditorView
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
    
    // MARK: - Subviews
    private var chatScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Helpful for new users to see what the app is about
                    if messages.isEmpty {
                        // welcomeHeader
                    }
                    
                    if !shouldHideInitialSuggestions {
                        chatSuggestionView
                    }
                    
                    ForEach(messages) { msg in
                        ChatBubbleView(message: msg)
                            .id(msg.id)
                    }
                }
                .padding()
            }
            .onChange(of: messages.count, { oldValue, newValue in
                scrollToBottom(proxy: proxy)
            })
        }
    }
    
    private var typingIndicator: some View {
        HStack(spacing: 8) {
            ProgressView()
                .tint(.orange)
            Text("Consulting Shastras...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.bottom, 8)
    }
    
    private var textEditorView: some View {
        HStack(spacing: 8.0) {
            ExpandingTextInput(text: $message)
            Button {
                sendQuery(text: message)
            } label: {
                Image(systemName: "paperplane")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Circle().fill(Color.orange.opacity(0.8)))
            }
        }
        .padding()
    }
    
    private var chatSuggestionView: some View {
        ForEach(verse.suggestedQuestions, id: \.self) { suggestion in
            
            ChatSuggestionsView(suggestion: suggestion) {
                sendQuery(text: suggestion)
            }
        }
    }
    
    private func sendQuery(text: String) {
        let currentMessage = ChatMessage(text: text, isUser: true)
        messages.append(currentMessage)
       
        // Clear the text editor.
        clearTextEditor()
        
        Task {
            isSending = true
            await executeQuery(query: currentMessage.text)
            isSending = false
        }
        
        // When first query is sent, hide the initial suggestions.
        shouldHideInitialSuggestions = true
    }
    
    @MainActor
    private func executeQuery(query: String) async {
        do {
            let answer = try await queryQuestion(query)
            messages.append(ChatMessage(text: answer, isUser: false))
        } catch {
            print("Failed to get answer: \(error.localizedDescription)")
        }
    }
    
    private func clearTextEditor() {
        message = ""
    }
    
    func queryQuestion(_ query: String) async throws -> String {
        do {
            let answer = try await NetworkManager.shared.askQuestion(question: query)
            return answer
        } catch {
            print("Error:", error.localizedDescription)
            return ""
        }
    }
    
    // Scroll to bottom when results are generated.
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastID = messages.first?.id else { return }
        
        withAnimation(.easeOut(duration: 0.3)) {
            proxy.scrollTo(lastID, anchor: .bottom)
        }
    }
}
