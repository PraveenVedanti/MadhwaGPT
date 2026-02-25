//
//  ScripturesView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/17/26.
//

import Foundation
import SwiftUI

struct ScripturesView: View {
    // MARK: - Properties
    
    @State private var selectedScripture: Scripture?
    @State private var isLoading = true
    @State private var showLibrary = false
    
    // View models.
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject var viewModel = ScriptureViewModel()
    
    var body: some View {
        NavigationStack {
            contentSection
                .navigationTitle(selectedScripture?.title ?? "Scriptures")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showLibrary) {
                    scriptureSelectionView
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showLibrary.toggle()
                        } label: {
                            Image(systemName: "books.vertical.fill")
                        }
                    }
                }
        }
        .task {
            await loadInitialData()
        }
    }
    
    // MARK: - Sub views
    @ViewBuilder
    private var contentSection: some View {
        if isLoading {
            ContentUnavailableView {
                Label("Loading Scriptures", systemImage: "book.pages")
            } description: {
                ProgressView()
            }
        } else if let scripture = selectedScripture {
            ScriptureChaptersView(scripture: scripture)
                .id(scripture.id)
        } else {
            ContentUnavailableView(
                "No Selection",
                systemImage: "book.closed",
                description: Text("Please select a scripture to begin reading.")
            )
        }
    }
    
    private var scriptureSelectionView: some View {
        NavigationStack {
            List(viewModel.scriptures) { scripture in
                ScriptureSelectionCard(
                    scripture: scripture,
                    isSelected: selectedScripture == scripture) {
                        selectedScripture = scripture
                        showLibrary.toggle()
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Explore sacred texts")
        }
    }
    
    // MARK: - Private Methods
    private func loadInitialData() async {
        guard viewModel.scriptures.isEmpty else { return }
        
        // Simulating network delay
        viewModel.loadScriptures()
        
        // Set default selection
        if let first = viewModel.scriptures.first {
            withAnimation {
                selectedScripture = first
                isLoading = false
            }
        }
    }
}


extension View {
    func divider() -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(height: 1)
    }
}

struct Scripture: Identifiable, Equatable {
    var id: String { title }
    let title: String
    let description: String
    let language: String
    let chaptersURLString: String
    
    // Meta data (Ex: Chapters, Sandhis)
    let firstMetaDataKey: String
    let firstMetaDataValue: String
    let secondMetaDataKey: String
    let secondMetaDataValue: String
    
    static func == (lhs: Scripture, rhs: Scripture) -> Bool {
        return lhs.title == rhs.title
    }
}

