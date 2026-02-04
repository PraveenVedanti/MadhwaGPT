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
    
    @State var answerText: String?
    
    // Use a state variable to track loading
    @State private var isSending = false
    @State private var didReceivedAnswer = false
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 12) {
                navigationBarView
                
                if isSending {
                    Text("Generating....")
                }
                
                if didReceivedAnswer {
                    ScrollView {
                        Text(answerText ?? "")
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                         
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.8), lineWidth: 1)
                    )
                    .padding()
                }
                
                Spacer()
                
                textEditorView
            }
            .onAppear {
                if viewModel.chatLevels.isEmpty {
                    viewModel.loadChatTypes()
                }
            }
            .background(backgroundColor)
        }
    }
    
    private var navigationBarView: some View {
        HStack {
            Spacer()
            settingsButtonView
        }
        .overlay {
            Text("MadhwaGPT")
                .font(.title)
        }
        .frame(maxWidth: .infinity)
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
        let currentMessage = message
        clearTextEditor()
        
        Task {
            isSending = true
            await sendQuery(query: currentMessage)
            isSending = false
        }
    }
    
    @MainActor
    private func sendQuery(query: String) async {
        do {
            let answer = try await viewModel.queryQuestion(query)
            self.answerText = answer
            didReceivedAnswer = true
        } catch {
            print("Failed to get answer: \(error.localizedDescription)")
            didReceivedAnswer = false
        }
    }
    
    private func clearTextEditor() {
        message = ""
    }
}
