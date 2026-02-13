//
//  ScriptureVerseDetailView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/10/26.
//

import Foundation
import SwiftUI

struct ScriptureVerseDetailView: View {
    let verseList: [ScriptureChapterVerse]
    
    @State private var currentIndex: Int
    @State private var showMeanings = false
    @State private var showAI = false
    
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
        NavigationStack {
            ZStack {
                Color(red: 1.0, green: 0.976, blue: 0.961).ignoresSafeArea()
                
                // Verse details view
                ScrollView {
                    ScriptureChapterVerseView(verse: selectedVerse)
                        .padding(.bottom, 120)
                }
                
                // Navigation and helper controls.
                VStack {
                    Spacer()
                    navigationDock
                }
            }
            .navigationTitle(selectedVerse.canonicalId)
            .navigationBarTitleDisplayMode(.large)
            .fullScreenCover(isPresented: $showMeanings) {
                WordByWordSheet(words: selectedVerse.wordByWord ?? [])
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showAI) {
                Text("Hello")
            }
        }
    }
    
    private var navigationDock: some View {
        HStack(spacing: 15) {
            // Previous Button
            Button(action: showPrevious) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(isFirstVerse ? .gray : .orange)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(.ultraThinMaterial))
            }
          
            .disabled(isFirstVerse)
            
            Spacer()
            
            // Study Tools (Central Pill)
            HStack(spacing: 4) {
                toolButton(title: "Meanings", icon: "character.book.closed") { showMeanings.toggle() }
                
                Divider().frame(height: 20).padding(.horizontal, 10)
                
                toolButton(title: "Ask AI", icon: "sparkles") { showAI.toggle() }
            }
            .padding(12)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(
                Capsule()
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            )
            
            Spacer()
            
            // Next Button
            Button(action: showNext) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(isLastVerse ? .gray : .orange)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(.ultraThinMaterial))
            }
            .disabled(isLastVerse)
        }
        .padding(8)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(.white.opacity(0.2), lineWidth: 0.5))
    }
    
    // MARK: - Helper View Builders
    private func toolButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                Text(title).font(.caption2).bold()
            }
        }
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

// MARK: - Word by Word meaning view.
struct WordByWordSheet: View {
    let words: [WordDetail]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Card Content
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach(words) { word in
                            HStack(alignment: .top, spacing: 16) {
                                // The Term
                                Text(word.word)
                                    .font(.system(.body, design: .serif))
                                    .bold()
                                    .foregroundColor(.brown)
                                    .frame(width: 110, alignment: .leading)
                                
                                // The Meaning
                                Text(word.meaning)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .lineSpacing(4)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            if word.id != words.last?.id {
                                Divider()
                                    .padding(.leading, 126) // Aligns divider with meaning text
                                    .opacity(0.6)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Word Meanings")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(red: 1.0, green: 0.976, blue: 0.961))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.orange)
                            .frame(width: 36, height: 36)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(.white.opacity(0.2), lineWidth: 0.5)
                            )
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                }
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
    
    let backgroundColor = Color(red: 1.0, green: 0.976, blue: 0.961)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            
            Divider()
            
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
