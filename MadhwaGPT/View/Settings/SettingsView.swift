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
    @State private var showChatLevelSelectionSheet = false
    
    
    var body: some View {
        NavigationStack {
            List {
               
                // Profile view.
                Section {
                    profileSection
                }
               
                // User level.
                Section {
                    chatLevelSelection
                } header: {
                    Text(MGPTStrings.SettingsTab.userLevelSectionTitle)
                }
                
                // Themes
                Section {
                    chatThemeSection
                } header: {
                    Text(MGPTStrings.SettingsTab.appearanceSectionTitle)
                }
                
                Section {
                    Toggle(MGPTStrings.SettingsTab.hideChatSuggestions, isOn: $viewModel.hideChatSuggestions)
                }
            }
            .task {
                loadInitialData()
            }
            .sheet(isPresented: $showChatThemeSelectionSheet) {
                chatThemeSelectionView
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showChatLevelSelectionSheet) {
                chatLevelSelectionListView
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .navigationTitle(MGPTStrings.SettingsTab.settingsTitle)
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(colorScheme == .dark ? .hidden : .visible)
            .background(Color(.systemBackground))
            .listStyle(.insetGrouped)
        }
    }
    
    // MARK: - Profile view sub views.
    private var profileSection: some View {
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
    
    // MARK: - Chat level sub views.
    private var chatLevelSelection: some View {
        HStack {
            Text(viewModel.selectedChatLevel)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 8)
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity)
        .onTapGesture {
            showChatLevelSelectionSheet.toggle()
        }
    }
    
    private var chatLevelSelectionListView: some View {
        NavigationStack {
            List {
                ForEach(viewModel.chatLevels) { chatLevel in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(chatLevel.title)
                                .foregroundStyle(.primary)
                                .font(.subheadline)
                            Text(chatLevel.description)
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        Spacer()
                        if viewModel.selectedChatLevel == chatLevel.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectedChatLevel = chatLevel.id
                        showChatLevelSelectionSheet.toggle()
                    }
                }
            }
            .navigationTitle(MGPTStrings.SettingsTab.chatLevelSheetTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Chat themes sub views.
    private var chatThemeSection: some View {
        HStack {
            Circle()
                .frame(width: 16, height: 16)
                .foregroundColor(viewModel.selectedChatThemeColor)
            
            Text(viewModel.selectedChatTheme)
            
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity)
        .onTapGesture {
            showChatThemeSelectionSheet.toggle()
        }
    }
    
    private var chatThemeSelectionView: some View {
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
            .navigationTitle(MGPTStrings.SettingsTab.chatThemeSheetTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Helper functions
    private func loadInitialData()  {
        guard viewModel.chatLevels.isEmpty else { return }
        guard viewModel.chatThemes.isEmpty else { return }
       
        // Load initial chat settings.
        viewModel.loadChatLevels()
        viewModel.loadChatThemes()
        
        // Set first theme by default.
        viewModel.selectedChatTheme = viewModel.chatThemes.first?.id ?? ""
        viewModel.selectedChatLevel = viewModel.chatLevels.first?.id ?? ""
    }
}
