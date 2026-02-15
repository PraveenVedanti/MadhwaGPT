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

    init(verse: ScriptureChapterVerse, verseList: [ScriptureChapterVerse]) {
        self.verseList = verseList
        // Find initial index immediately or default to 0
        let initialIndex = verseList.firstIndex(of: verse) ?? 0
        _currentIndex = State(initialValue: initialIndex)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                ScrollView {
                    ScriptureChapterVerseView(verse: selectedVerse)
                        .padding(.bottom, 120)
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle(selectedVerse.canonicalId)
            .navigationBarTitleDisplayMode(.large)
            .fullScreenCover(isPresented: $showAI) {
                AIInsightsView(verse: selectedVerse)
            }
        }
        .overlay(alignment: .bottomTrailing, content: {
            Button {
                showAI.toggle()
            } label: {
                Image(systemName: "sparkles")
                    .font(.title2.bold())
                    .foregroundColor(.orange)
                    .frame(width: 52, height: 52)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
            .padding()
        })
    }
    
    private var navigationDock: some View {
        HStack(spacing: 15) {
            // Previous Button
            //            Button(action: showPrevious) {
            //                Image(systemName: "chevron.left")
            //                    .font(.system(size: 18, weight: .bold))
            //                    .foregroundColor(isFirstVerse ? .gray : .orange)
            //                    .frame(width: 44, height: 44)
            //                    .background(Circle().fill(.ultraThinMaterial))
            //            }
            //
            //            .disabled(isFirstVerse)
            
            //            Spacer()
            Spacer()
            toolButton(title: "Ask AI", icon: "sparkles") { showAI.toggle() }
                .padding(12)
                .background(.ultraThinMaterial, in: Capsule())
                .overlay(
                    Capsule()
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
            
            //  Spacer()
            
            // Next Button
            //            Button(action: showNext) {
            //                Image(systemName: "chevron.right")
            //                    .font(.system(size: 18, weight: .bold))
            //                    .foregroundColor(isLastVerse ? .gray : .orange)
            //                    .frame(width: 44, height: 44)
            //                    .background(Circle().fill(.ultraThinMaterial))
            //            }
            //            .disabled(isLastVerse)
            //        }
            //        .padding(8)
            //        .clipShape(Capsule())
            //        .overlay(Capsule().stroke(.white.opacity(0.2), lineWidth: 0.5))
        }
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
    var words: [WordDetail] = []
    
    init(verse: ScriptureChapterVerse) {
        self.verse = verse
        self.words = verse.wordByWord ?? []
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VerseContentCard(verse: verse)
                wordByWordCard
                englishTranslationCard
            }
        }
        .background(Color(.systemBackground))
    }
    
    private var wordByWordCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("WORD-BY-WORD MEANINGS")
                .font(.system(size: 12, weight: .black))
                .kerning(1)
                .foregroundColor(.orange)
            
            Spacer()
                .frame(height: 8)
            
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
                        .padding(.leading, 126)
                        .opacity(0.6)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                // Use secondaryGroupedBackground for a premium "inset" look
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                // Subtle hairline border that only appears in dark mode to define edges
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
        // High-dispersion shadow that disappears in dark mode for a flat-modern feel
        .shadow(color: Color.black.opacity(0.04), radius: 20, x: 0, y: 10)
        .padding()
    }
    
    private var englishTranslationCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            titleHeader(title: "ENGLISH TRANSLATION", color: .orange)
            titleDescription(description: verse.translationEnglish, color: .primary.opacity(0.6), design: .rounded)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                // Use secondaryGroupedBackground for a premium "inset" look
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                // Subtle hairline border that only appears in dark mode to define edges
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
        // High-dispersion shadow that disappears in dark mode for a flat-modern feel
        .shadow(color: Color.black.opacity(0.04), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 12)
        .padding(.vertical)
    }
    
    private func titleHeader(title: String, color: Color) -> some View {
        Text(title)
            .font(.system(size: 12, weight: .black))
            .kerning(1)
            .foregroundColor(color)
    }
    
    private func titleDescription(description: String, color: Color, design: Font.Design) -> some View {
        Text(description)
            .font(.system(size: 20, weight: .regular, design: design))
            .lineSpacing(2)
            .foregroundColor(color)
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
    let verse: ScriptureChapterVerse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            if let sanskrit = verse.sanskrit {
                // 1. Primary Verse
                VStack(alignment: .leading, spacing: 8) {
                    titleHeader(title: "SANSKRIT (DEVANAGARI)", color: .orange)
                    titleDescription(description: sanskrit, color: .primary, design: .serif)
                }
            }
            
            if let kannada = verse.kannada {
                VStack(alignment: .leading, spacing: 8) {
                    titleHeader(title: "KANNADA", color: .orange)
                    titleDescription(description: kannada, color: .primary, design: .serif)
                }
            }
            
            // 2. Transliteration
            VStack(alignment: .leading, spacing: 8) {
                titleHeader(title: "TRANSLITERATION", color: .secondary.opacity(0.6))
                
                Text(verse.transliteration)
                    .font(.system(.body, design: .serif))
                    .italic()
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                // Use secondaryGroupedBackground for a premium "inset" look
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                // Subtle hairline border that only appears in dark mode to define edges
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
        // High-dispersion shadow that disappears in dark mode for a flat-modern feel
        .shadow(color: Color.black.opacity(0.04), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 12)
        .padding(.vertical)
    }
    
    private func titleHeader(title: String, color: Color) -> some View {
        Text(title)
            .font(.system(size: 12, weight: .black))
            .kerning(1)
            .foregroundColor(color)
    }
    
    private func titleDescription(description: String, color: Color, design: Font.Design) -> some View {
        Text(description)
            .font(.system(size: 20, weight: .medium, design: design))
            .lineSpacing(2)
            .foregroundColor(color)
    }
}
