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
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 12) {
                
                navigationBarView
                
                chatLevelSelectionView
                
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
    
    private var chatLevelSelectionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16.0) {
                ForEach(viewModel.chatLevels) { level in
                    Chip(
                        title: level.title,
                        isSelected: level.title.contains("Beginner")
                    ) {
                       
                    }
                }
            }
        }
        .padding(.horizontal, 12)
    }
    
    private var textEditorView: some View {
        HStack(spacing: 8.0) {
            ExpandingTextInput(text: $message)
            
            Button {
                print("Send tapped : \(message)")
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
            print("Settings tapped")
        } label: {
            Image(systemName: "gear")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.secondary)
                .padding(16)
                .clipShape(Circle())
        }
    }
}
