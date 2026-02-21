//
//  SettingsView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/14/26.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = SettingsViewModel()
    
    @State private var showChatThemeSelectionSheet = false
    
    var body: some View {
        NavigationStack {
            List {
               
                // Profile view.
                Section {
                    profileView
                }
               
                // User level.
                Section {
                    userLevelSection
                } header: {
                    Text("USER LEVEL")
                }
                
                // Themes
                Section {
                    HStack {
                        Text(viewModel.selectedChatTheme)
                            .foregroundStyle(.primary)
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        showChatThemeSelectionSheet.toggle()
                    }
                } header: {
                    Text("APPEARANCE")
                }
            }
            .task {
                loadInitialData()
            }
            .sheet(isPresented: $showChatThemeSelectionSheet) {
                chatThemeSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(colorScheme == .dark ? .hidden : .visible)
            .background(Color(.systemBackground))
            .listStyle(.insetGrouped)
        }
    }
    
    private var userLevelSection: some View {
        ForEach(viewModel.chatLevels) { level in
            VStack(alignment: .leading) {
                Text(level.title)
                    .foregroundStyle(.primary)
                    .font(.subheadline)
                Text(level.description)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            .padding(.horizontal, 8)
        }
    }
    
    private var chatThemeSection: some View {
        NavigationStack {
            List {
                ForEach(viewModel.chatThemes) { chatTheme in
                    HStack(spacing: 16) {
                        Circle()
                            .frame(width: 16, height: 16)
                            .foregroundColor(chatTheme.color)
                        
                        VStack(alignment: .leading) {
                            Text(chatTheme.title)
                                .foregroundStyle(.primary)
                                .font(.subheadline)
                            Text(chatTheme.description)
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        if viewModel.selectedChatTheme == chatTheme.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectedChatTheme = chatTheme.id
                        showChatThemeSelectionSheet.toggle()
                    }
                }
            }
            .navigationTitle("Select the theme")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var profileView: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundColor(.secondary)
                Text("P")
            }
            VStack(alignment: .leading) {
                Text("Your name")
                    .foregroundStyle(.primary)
                    .font(.subheadline)
                Text("Your e-mail")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    private func loadInitialData()  {
        guard viewModel.chatLevels.isEmpty else { return }
        guard viewModel.chatThemes.isEmpty else { return }
       
        // Load initial chat settings.
        viewModel.loadChatLevels()
        viewModel.loadChatThemes()
        
        // Set first theme by default.
        viewModel.selectedChatTheme = viewModel.chatThemes.first?.id ?? ""
    }
}
