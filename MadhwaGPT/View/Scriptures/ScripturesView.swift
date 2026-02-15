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
    
    let backgroundColor = Color(red: 1.0, green: 0.976, blue: 0.961)
    
    @StateObject var viewModel = ScriptureViewModel()
    @State private var selectedScripture: Scripture?
    @State private var isLoading = true
    
    @State private var showLibrary = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                contentSection
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
            .sheet(isPresented: $showLibrary) {
                ScriptureLibrarySheet(
                    selectedScripture: $selectedScripture,
                    allScriptures: viewModel.scriptures
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
            .navigationTitle(selectedScripture?.title ?? "Scriptures")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.clear)
            .task {
                await loadInitialData()
            }
        }
    }
    
    // MARK: - View Components
    @ViewBuilder
    private var contentSection: some View {
        if isLoading {
            ContentUnavailableView {
                Label("Loading Scriptures", systemImage: "book.pages")
            } description: {
                ProgressView()
            }
        } else if let scripture = selectedScripture {
            ScrollView {
                ScriptureChaptersView(scripture: scripture)
                    .padding(.top)
                    .id(scripture.id)
            }
        } else {
            ContentUnavailableView(
                "No Selection",
                systemImage: "book.closed",
                description: Text("Please select a scripture to begin reading.")
            )
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

struct ScriptureLibrarySheet: View {
   
    let backgroundColor = Color(red: 1.0, green: 0.976, blue: 0.961)
    @Binding var selectedScripture: Scripture?
    let allScriptures: [Scripture]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            ScrollView {
                VStack(spacing: 16) {
                    Spacer()
                        .frame(height: 60)
                    headerView
                    content
                }
                .frame(maxWidth: .infinity)
            }
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .padding(12)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .padding()
        }
       // .background(Color("SaffronViewBackground"))
        // .background(backgroundColor)
    }

    
    private var content: some View {
        VStack(spacing: 16) {
            ForEach(allScriptures) { scripture in
                Button {
                    selectedScripture = scripture
                    dismiss()
                } label: {
                    CyberNaturalistCard(scripture: scripture, isActive: selectedScripture == scripture)
                }
            }
        }
        .padding()
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            
            Text(Strings.scripturesTitle)
                .foregroundStyle(Color.orange)
                .font(.title)
            
            Text(Strings.scripturesHeader)
                .foregroundStyle(.primary)
                .font(.headline)
        }
        .padding(.leading, 8.0)
        .frame(maxWidth: .infinity)
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

struct CyberNaturalistCard: View {
    let scripture: Scripture
    let isActive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
        
            HStack(spacing: 16) {
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 40))
                   // .foregroundStyle(.orange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(scripture.title)
                        .font(.system(.title3, design: .serif))
                        .bold()
                        .foregroundColor(.primary)
                    
                    Text(scripture.description)
                        .font(.system(.subheadline, design: .serif))
                        .foregroundColor(.secondary.opacity(0.8))
                }
                Spacer()
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(cardGradient)
            )

            // 2. Language & Metadata Section
            VStack(alignment: .leading, spacing: 12) {
                Text(scripture.language)
                    .font(.system(.headline, design: .serif))
                    .foregroundColor(.primary)
                
                metadataView
            }
            .padding(.horizontal, 8)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
        .shadow(
            color: .black.opacity(0.05),
            radius: isActive ? 20 : 8,
            x: 0,
            y: isActive ? 10 : 4
        )
        .scaleEffect(isActive ? 1.02 : 1.0)
    }
    
    private var cardGradient: LinearGradient {
        return LinearGradient(
            colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // Updated metadataView for better spacing
    private var metadataView: some View {
        HStack(spacing: 12) {
            Group {
                Text(scripture.firstMetaDataValue).bold() +
                Text(" \(scripture.firstMetaDataKey)").foregroundColor(.secondary)
            }
            .font(.subheadline)
            
            Divider()
                .frame(height: 14)
            
            Group {
                Text(scripture.secondMetaDataValue).bold() +
                Text(" \(scripture.secondMetaDataKey)").foregroundColor(.secondary)
            }
            .font(.subheadline)
        }
    }
}
