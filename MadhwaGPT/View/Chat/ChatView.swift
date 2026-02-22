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
    
    // Chat view model.
    @ObservedObject var viewModel = ChatViewModel()
    
    @State private var messages: [ChatMessage] = []
    
    // Use a state variable to track loading
    @State private var isSending = false
    
    // State variable to show/hide initial suggestions.
    @State private var shouldHideInitialSuggestions = false
    
    @State private var showChatSuggestionsSheet = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 12) {
                
                chatScrollView
                
                if isSending {
                    typingIndicator
                }
                
                VStack {
                    if !shouldHideInitialSuggestions { chatSuggestionView }
                    textEditorView
                }
            }
            .navigationTitle("Chat")
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
                loadInitialData()
            }
            .background(colorScheme == .light ? Color(.systemBackground) : Color(uiColor: .secondarySystemBackground))
            .sheet(isPresented: $showChatSuggestionsSheet) {
                chatSuggestionListView
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
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

            Text(Strings.welcomeHeaderTitle)
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
        VStack {
            HStack {
                Label("Try asking:", systemImage: "lightbulb")
                    .font(.title3)
                    .foregroundStyle(.orange)
                Spacer()
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                suggestionCarousel
                    .padding(.horizontal, 16)
            }
        }
    }
    
    private var suggestionCarousel: some View {
        HStack(spacing: 16.0) {
            ForEach(viewModel.initialChatSuggestions) { suggestion in
                Chip(
                    title: suggestion.suggestion,
                    isSelected: false) {
                        sendQuery(text: suggestion.suggestion)
                    }
            }
            
            // More suggestions button.
            moreSuggestionButton
        }
    }
    
    private var moreSuggestionButton: some View {
        Button {
            showChatSuggestionsSheet = true
        } label: {
           HStack(spacing: 4) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.orange)
                Text("More")
                   .font(.footnote)
                    .fontWeight(.medium)
            }
            .frame(width: 96, height: 48)
            .background(
                Capsule()
                    .fill(Color.secondary.opacity(0.1))
            )
        }
        .buttonStyle(.plain)
    }
    
    private var chatSuggestionListView: some View {
        NavigationStack {
            List {
                ForEach(viewModel.chatSuggestions) { suggestion in
                    ChatSuggestionCard(text: suggestion.suggestion, font: suggestion.suggestionFont) {
                        sendQuery(text: suggestion.suggestion)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Try asking")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
