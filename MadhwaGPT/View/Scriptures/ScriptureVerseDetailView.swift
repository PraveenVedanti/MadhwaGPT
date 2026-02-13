//
//  ScriptureVerseDetailView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/10/26.
//

import Foundation
import SwiftUI

enum ScriptureVerseDetailTab: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case verse = "Verse"
    case word = "Word by word meanings"
    case ai = "Ask AI"
}

struct ScriptureVerseDetailView: View {
    let verseList: [ScriptureChapterVerse]
    
    @State private var currentIndex: Int
    @State private var currentTab: ScriptureVerseDetailTab = .verse
    @State private var isSheetPresented = false
    
    @State private var selectedTab: ScriptureVerseDetailTab = .verse
    
    // Derived state for the currently visible verse
    private var selectedVerse: ScriptureChapterVerse {
        verseList[currentIndex]
    }
    
    // Boundary check variables.
    private var isFirstVerse: Bool { currentIndex == 0 }
    private var isLastVerse: Bool { currentIndex == verseList.count - 1 }
    
    let backgroundColor = Color(red: 1.0, green: 0.976, blue: 0.961)

    init(verse: ScriptureChapterVerse, verseList: [ScriptureChapterVerse]) {
        self.verseList = verseList
        // Find initial index immediately or default to 0
        let initialIndex = verseList.firstIndex(of: verse) ?? 0
        _currentIndex = State(initialValue: initialIndex)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView(.horizontal, showsIndicators: false) {
                headerView
            }
    
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 16) {
                    switch selectedTab {
                    case .verse:
                        ScriptureChapterVerseView(verse: selectedVerse)
                    case .word:
                        Text("Word Detail View")
                    case .ai:
                        Text("AI Insights")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            navigationToolbar
                .padding(.top, 8)
                .background(Material.bar)
        }
        .background(backgroundColor)
        .navigationTitle(selectedVerse.canonicalId)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack(spacing: 16.0) {
            ForEach(ScriptureVerseDetailTab.allCases) { tab in
                Chip(title: tab.rawValue,
                     isSelected: selectedTab.id == tab.id
                ) {
                    selectedTab = tab
                }
            }
        }
        .padding()
    }
    
    private var navigationToolbar: some View {
        HStack {
            // Previous Button
            Button(action: showPrevious) {
                Label("Previous", systemImage: "chevron.left")
            }
            .buttonStyle(ScriptureNavigationButtonStyle(color: isFirstVerse ? .secondary : .orange))
            .disabled(isFirstVerse)
            
            Spacer()
            
            // Next Button
            Button(action: showNext) {
                HStack {
                    Text("Next")
                    Image(systemName: "chevron.right")
                }
            }
            .buttonStyle(ScriptureNavigationButtonStyle(color: isLastVerse ? .secondary : .orange))
            .disabled(isLastVerse)
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
        .background(backgroundColor)
    }
    
    // MARK: - Actions
    
    private func showPrevious() {
        guard !isFirstVerse else { return }
        withAnimation(.easeInOut(duration: 0.05)) {
            currentIndex -= 1
        }
    }
    
    private func showNext() {
        guard !isLastVerse else { return }
        withAnimation(.easeInOut(duration: 0.05)) {
            currentIndex += 1
        }
    }
}

// MARK: - Navigation button style

struct ScriptureNavigationButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.medium)
            .foregroundColor(configuration.isPressed ? color.opacity(0.5) : color)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.clear))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color, lineWidth: 0.5)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

// MARK: - Verse view

struct ScriptureChapterVerseView: View {
    
    let verse: ScriptureChapterVerse
    
    @State private var isSheetPresented = false
    
    init(verse: ScriptureChapterVerse) {
        self.verse = verse
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ScrollView {
                
                // Used for Bhagavatgeetha
                if let sanskrit = verse.sanskrit {
                    VerseContentCard(title: "SANSKRIT (DEVANAGARI)", text: sanskrit)
                }
                
                // Used for HKS
                if let kannada = verse.kannada {
                    VerseContentCard(title: "KANNADA TEXT", text: kannada)
                }
                
                VerseContentCard(title: "TRANSLITERATION", text: verse.transliteration)
                
                VerseContentCard(title: "ENGLISH TRANSLATION", text: verse.translationEnglish)
            }
        }
    }
}

// MARK: - AI Insights view.

struct ScriptureAIInsightView: View {
    var body: some View {
        Text("AI Tab")
    }
}

// MARK: - Verse content card.

struct VerseContentCard: View {
    let title: String
    let text: String
    var isItalic: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                Spacer()
                Button(action: { UIPasteboard.general.string = text }) {
                    Image(systemName: "doc.on.doc")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(text)
                .font(.system(size: 18, weight: .regular, design: .serif))
                .italic(isItalic)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
        .padding(.horizontal, 8)
    }
}
