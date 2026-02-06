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
    let backgroundColor = Color(red: 1.0, green: 0.976, blue: 0.961)
    
    @ObservedObject var viewModel = ChatViewModel()
    
    @State private var messages: [ChatMessage] = []
    
    // Use a state variable to track loading
    @State private var isSending = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 12) {
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(messages) { msg in
                                ChatBubbleView(message: msg)
                                    .id(msg.id)
                            }
                        }
                        .padding(.vertical)
                    }
                    .onChange(of: messages.count, { oldValue, newValue in
                        scrollToBottom(proxy: proxy)
                    })
                }
                
                if isSending {
                    HStack {
                        Image(systemName: "slomo")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Circle().fill(Color.orange.opacity(0.8)))
                        Text("Generating....")
                    }
                    
                }
                
                Divider()
                
                textEditorView
            }
            .navigationTitle("MadhwaGPT")
            .toolbar {
                // Top Right Button
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        print("Settings Tapped")
                        // Action: Clear messages or start new session
                    } label: {
                        Image(systemName: "gear")
                    }
                }
                
                ToolbarItem(placement: .navigation) {
                    Button {
                        print("Slider Tapped")
                        // Action: Clear messages or start new session
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }

            }
            .onAppear {
                if viewModel.chatLevels.isEmpty {
                    viewModel.loadChatTypes()
                }
            }
            .background(backgroundColor)
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastID = messages.last?.id else { return }
        
        withAnimation(.easeOut(duration: 0.3)) {
            proxy.scrollTo(lastID, anchor: .bottom)
        }
    }
    
    private var textEditorView: some View {
        HStack(spacing: 8.0) {
            ExpandingTextInput(text: $message)
            Button {
                sendQuery()
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
    
    private var settingsButtonView: some View {
        Button {
        } label: {
            Image(systemName: "gear")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.secondary)
                .padding(16)
                .clipShape(Circle())
        }
    }
    
    private func sendQuery() {
        let currentMessage = ChatMessage(text: message, isUser: true)
        messages.append(currentMessage)
       
        // Clear the text editor.
        clearTextEditor()
        
        Task {
            isSending = true
            await sendQuery(query: currentMessage.text)
            isSending = false
        }
    }
    
    @MainActor
    private func sendQuery(query: String) async {
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
