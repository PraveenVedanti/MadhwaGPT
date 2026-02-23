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
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 12) {
                
                chatScrollView
                
                if isSending {
                    typingIndicator
                }
                
                // Hide chat suggestion when chat is in progress and
                // Keyboard is focused.
                if !shouldHideInitialSuggestions && !isTextFieldFocused {
                    chatSuggestionView
                }
                textEditorView
            }
            .onTapGesture {
                isTextFieldFocused = false
                print("tapped")
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
                LazyVStack(spacing: 16) {
                   
                    if messages.isEmpty {
                        welcomeHeader
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
    
    private var welcomeHeader: some View {
        VStack {
            Image("madhwaImage")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                       .overlay(
                           Circle()
                               .stroke(Color.gray, lineWidth: 2)
                       )

            Text(MGPTStrings.ChatTab.welcomeHeaderTitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
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
        HStack(spacing: 8.0) {
            ExpandingTextInput(
                text: $message,
                isFocused: $isTextFieldFocused
            )
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
    
    private func setBGColor() {
        backgroundColor =  ColorTokens.setBackgroundColor(theme: settingsViewModel.selectedChatTheme)
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
        VStack(alignment: .leading) {
            Label {
                Text(MGPTStrings.ChatTab.tryAsking)
            } icon: {
                Image(systemName: "sparkles")
            }
            .padding()
           
            chatSuggestionCarousel
        }
    }
    
    private var chatSuggestionCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(
                rows: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(viewModel.chatSuggestions) { question in
                    SuggestionCard(
                        question: question.suggestion) {
                            sendQuery(text: question.suggestion)
                        }
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 240)
    }
}
