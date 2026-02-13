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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerSection
                
                contentSection
            }
            .navigationTitle("Scriptures")
            .navigationBarTitleDisplayMode(.inline)
            .background(backgroundColor)
            .task {
                await loadInitialData()
            }
        }
    }
    
    // MARK: - View Components
    private var headerSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.scriptures) { scripture in
                    Chip(
                        title: "\(scripture.title)  - \(scripture.language)",
                        isSelected: scripture == selectedScripture
                    ) {
                        selectedScripture = scripture
                    }
                }
            }
            .padding()
        }
    }
    
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
    
    // MARK: - Subviews
    private var headerView: some View {
        HStack(spacing: 12.0) {
            ForEach(viewModel.scriptures) { scripture in
                Chip(
                    title: scripture.title,
                    isSelected: scripture.title == selectedScripture?.title
                ) {
                    selectedScripture = scripture
                }
            }
        }
        .padding(.horizontal)
        .frame(minWidth: UIScreen.main.bounds.width, alignment: .center)
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


struct Strings {
    static let scripturesTitle = NSLocalizedString("Explore Sacred Texts", comment: "Scriptures page title")
    static let scripturesHeader = NSLocalizedString("Explore sacred verses with detailed meanings and translations", comment: "Scriptures page header")
    static let scripturesSubHeader = NSLocalizedString("AI-guided insights from the Madhva guru parampara tradition"
                                            , comment: "Scriptures page header")
    static let chatTitle = NSLocalizedString("Your guide to Madhvacharya's Dvaita Vedanta philosophy", comment: "Chat page title")
    static let welcomeHeaderTitle = NSLocalizedString("Your guide to Madhvacharya's Dvaita Vedanta philosophy", comment: "welcome header title")
}
