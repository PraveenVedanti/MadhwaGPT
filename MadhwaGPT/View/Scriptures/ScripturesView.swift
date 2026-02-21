//
//  ScripturesView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/17/26.
//

import Foundation
import SwiftUI

import SwiftUI

struct ScripturesView: View {
    // MARK: - Properties
    
    @StateObject var viewModel = ScriptureViewModel()
    @State private var selectedScripture: Scripture?
    @State private var isLoading = true
    
    @State private var showLibrary = false
    
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
                .background(Color("SaffronCardBackround"))
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


struct ScriptureCard: View {
    
    let scripture: Scripture
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            titleView
            
            descriptionView
            
            Spacer()
                .frame(height: 12)
            
            metadDataView
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
        .padding(.horizontal, 12)
    }
    
    private var titleView: some View {
        HStack {
            Text(scripture.title)
                .font(.headline)
            
            Spacer()
            
            Text(scripture.language)
                .font(.subheadline)
                .foregroundColor(.orange)
        }
    }
    
    private var descriptionView: some View {
        Text(scripture.description)
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
    
    private var metadDataView: some View {
        HStack {
            Text(scripture.firstMetaDataKey)
                .fontWeight(.semibold)
                .font(.system(size: 18))
                
            Text(scripture.firstMetaDataValue)
                .foregroundColor(.gray)
                .font(.subheadline)
            
            Divider()
                .frame(height: 20)
                .background(Color.gray)
            
            Text(scripture.secondMetaDataKey)
                .fontWeight(.semibold)
                .font(.system(size: 18))

            Text(scripture.secondMetaDataValue)
                .foregroundColor(.gray)
                .font(.subheadline)
        }
    }
}

// Helper to make the UI look cleaner
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

