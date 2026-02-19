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
    
    // State variable for show settings view.
    @State private var shouldShowSettings = false
    
    // State variable to show/hide initial suggestions.
    @State private var shouldHideInitialSuggestions = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 12) {
                
                chatScrollView
                
                if isSending {
                    typingIndicator
                }
                
               textEditorView
        
            }
            .navigationTitle("MadhwaGPT")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                // Top Right Button
                ToolbarItem(placement: .topBarTrailing) {
                    settingsView
                }
                // Top Left Button
                ToolbarItem(placement: .topBarLeading) {
                    chatHistory
                }
            }
            .onAppear {
                loadInitialData()
            }
            .background(Color(.systemBackground))
            .sheet(isPresented: $shouldShowSettings, content: {
                SettingsView()
            })
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
                        HStack {
                            Label("Try asking:", systemImage: "lightbulb")
                                .foregroundStyle(Color.orange)
                            Spacer()
                        }
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
    
    private var settingsView: some View {
        Button {
            if shouldHideInitialSuggestions {
                shouldHideInitialSuggestions = false
                messages.removeAll()
            }
        } label: {
            Image(systemName: "bubble.and.pencil")
       }
    }
    
    private var chatHistory: some View {
        Button {
            print("Slider Tapped")
        } label: {
            Image(systemName: "slider.horizontal.3")
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
    
    private var chatSuggestionView: some View {
        ForEach(viewModel.initialSuggestions) { suggestion in
            ChatSuggestionCard(text: suggestion.suggestion) {
                sendQuery(text: suggestion.suggestion)
            }
        }
    }
    
    private func loadInitialData() {
        if viewModel.initialSuggestions.isEmpty {
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

