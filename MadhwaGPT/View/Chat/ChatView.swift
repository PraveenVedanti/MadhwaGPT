//
//  ChatView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/17/26.
//

import Foundation
import SwiftUI

struct ChatView: View {
    
    @State private var message = ""
    
    // View models.
    @ObservedObject var viewModel = ChatViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    @State private var messages: [ChatMessage] = []
    
    // Use a state variable to track loading
    @State private var isSending = false
    
    // State variable to show/hide initial suggestions.
    @State private var shouldHideInitialSuggestions = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var backgroundColor: Color = Color(.systemBackground)
    @State private var textFontColor: Color = Color(.label)
    
    @AppStorage("hideChatSuggestions") var hideChatSuggestions: Bool = false
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 0) {
                
                // Show welcome header only when chat is not in progress.
                if messages.isEmpty && !isTextFieldFocused  {
                    welcomeHeader
                }
                
                chatScrollView
                
                if isSending {
                    typingIndicator
                }
                
                // Hide chat suggestion when chat is in progress and
                // Keyboard is focused.
                if !shouldHideInitialSuggestions && !isTextFieldFocused && !hideChatSuggestions {
                    chatSuggestionView
                }
                textEditorView
            }
            .onTapGesture {
                isTextFieldFocused = false
            }
            .navigationTitle(MGPTStrings.ChatTab.chatNavigationBarTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Top Right Button
                ToolbarItem(placement: .topBarTrailing) {
                    newChatView
                }
                // Top Left Button
                ToolbarItem(placement: .topBarLeading) {
                    chatHistory
                }
            }
            .onAppear {
                setBGColor()
                loadInitialData()
            }
            .background(backgroundColor)
        }
    }
    
    // MARK: - Subviews
    private var chatScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(messages) { msg in
                        ChatBubbleView(message: msg, textColor: textFontColor)
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
    
    private var welcomeHeader: some View {
        VStack {
            Image("madhwaImage")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(textFontColor, lineWidth: 2)
                )
            Text(MGPTStrings.ChatTab.welcomeHeaderTitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }

    private var typingIndicator: some View {
        HStack(spacing: 8) {
            ProgressView()
                .tint(textFontColor)
            Text(MGPTStrings.ChatTab.textGenerationString)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.bottom, 8)
    }
    
    private var newChatView: some View {
        Button {
            if shouldHideInitialSuggestions {
                shouldHideInitialSuggestions = false
                messages.removeAll()
            }
        } label: {
            Image(systemName: "bubble.and.pencil")
                .font(.system(size: 14))
       }
    }
    
    private var chatHistory: some View {
        Button {
            print("Slider Tapped")
        } label: {
            Text("㆔")
        }
    }
    
    private var textEditorView: some View {
        ExpandingTextInput(
            text: $message,
            isFocused: $isTextFieldFocused,
            backgroundColor: backgroundColor,
            fontColor: textFontColor
        ) {
            sendQuery(text: message)
        }
    }
    
    private func setBGColor() {
        backgroundColor =  ColorTokens.setBackgroundColor(theme: settingsViewModel.selectedChatTheme)
        textFontColor = ColorTokens.setTextColor(theme: settingsViewModel.selectedChatTheme)
    }

    private func loadInitialData() {
        if viewModel.chatSuggestions.isEmpty {
            viewModel.loadChatSuggestions()
        }
    }

    // Scroll to bottom when results are generated.
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastID = messages.first?.id else { return }
        
        withAnimation(.easeOut(duration: 0.3)) {
            proxy.scrollTo(lastID, anchor: .bottom)
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
            let answer = try await viewModel.queryQuestion(query)
            messages.append(ChatMessage(text: answer, isUser: false))
        } catch {
            print("Failed to get answer: \(error.localizedDescription)")
        }
    }
    
    private func clearTextEditor() {
        message = ""
    }
}

// MARK: - Chat suggestion sub views
extension ChatView {
    
    private var chatSuggestionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            chatSuggestionChip
        }
    }
    
    private var chatSuggestionChip: some View {
        HStack(spacing: 16.0) {
            ForEach(viewModel.chatSuggestions) { suggestion in
                Chip(
                    text: suggestion.suggestion,
                    isSelected: false,
                    backgroundColor: backgroundColor,
                    fontColor: textFontColor.opacity(0.05)
                ) {
                    sendQuery(text: suggestion.suggestion)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
