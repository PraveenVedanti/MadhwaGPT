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
    @State private var showAI = false
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    @State private var backgroundColor: Color = Color(.systemBackground)
    @State private var textFontColor: Color = .primary
    
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
            ScriptureChapterVerseView(verse: selectedVerse)
                .background(backgroundColor)
                .navigationTitle(selectedVerse.canonicalId)
                .navigationBarTitleDisplayMode(.inline)
                .fullScreenCover(isPresented: $showAI) {
                    AIInsightsView(verse: selectedVerse)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 16) {
                            previousVerseButton
                            nextVerseButton
                            askAIButton
                        }
                    }
                }
                .onAppear {
                    setThemes()
                }
        }
    }
    
    private func setThemes() {
        backgroundColor =  ColorTokens.setBackgroundColor(theme: settingsViewModel.selectedChatTheme)
        textFontColor = ColorTokens.setTextColor(theme: settingsViewModel.selectedChatTheme)
    }
    
    private var askAIButton: some View {
        Button {
            showAI.toggle()
        } label: {
            Image(systemName: "sparkles")
                .foregroundStyle(.primary)
                .font(.system(size: 16, weight: .regular))
        }
    }
    
    private var previousVerseButton: some View {
        Button {
            showPrevious()
        } label: {
            Image(systemName: "arrow.left")
                .foregroundStyle(.primary)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(isFirstVerse ? .secondary.opacity(0.3) : .primary)
        }
        .disabled(isFirstVerse)
    }
    
    private var nextVerseButton: some View {
        Button {
            showNext()
        } label: {
            Image(systemName: "arrow.right")
                .foregroundStyle(.primary)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(isLastVerse ? .secondary.opacity(0.3) : .primary)
        }
        .disabled(isLastVerse)
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
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var backgroundColor: Color = Color(.systemBackground)
    
    // Font color of the text inside chip.
    @State private var fontColor: Color = .primary
    
    init(verse: ScriptureChapterVerse) {
        self.verse = verse
        self.words = verse.wordByWord ?? []
    }
    
    var body: some View {
        
        ZStack {
            
            backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
               
                VStack(alignment: .leading, spacing: 24) {
                    
                    verseCard
                    
                    transliterationCard
                    
                    Divider()
                    
                    wordByWordCard
                    
                    Divider()
                  
                    englishTranslationCard
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
            }
        }
        .onAppear {
            setThemes()
        }
    }
    
    private func setThemes() {
        backgroundColor =  ColorTokens.setBackgroundColor(theme: settingsViewModel.selectedChatTheme)
        fontColor = ColorTokens.setTextColor(theme: settingsViewModel.selectedChatTheme)
    }
    
    private var verseCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Verse header view
            if let _ = verse.sanskrit {
                sectionHeader(title: "SANSKRIT (DEVANAGARI)")
            }
            
            if let _ = verse.kannada {
                sectionHeader(title: "KANNADA")
            }
            
            verseContentView
        }
    }
    
    private var transliterationCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader(title: "TRANSLITERATION")
            transliterationContentView
        }
    }
    
    private var wordByWordCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader(title: "WORD-BY-WORD MEANINGS")
            wordByWordContent
        }
    }
    
    private var englishTranslationCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader(title: "ENGLISH TRANSLATION")
            englishTranslationContent
        }
    }
    
    
    private var verseContentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if let sanskrit = verse.sanskrit {
                sectionDescription(description: sanskrit)
                    .multilineTextAlignment(.leading)
            }
            
            if let kannada = verse.kannada {
                sectionDescription(description: kannada)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
        )
    }
    
    private var transliterationContentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionDescription(description: verse.transliteration)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
        )
    }
    
 
    var wordByWordContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 16) {
               
                ForEach(words) { word in
                    GridRow(alignment: .top) {
                        
                        // Word
                        Text(word.word)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.primary.opacity(0.5))
                            .multilineTextAlignment(.leading)
                        
                        // Meaning
                        Text(word.meaning)
                            .font(.system(.body, design: .serif))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    if word.id != words.last?.id {
                        Divider().padding(.top, 8)
                    }
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
        )
    }
    
    private var englishTranslationContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionDescription(description: verse.translationEnglish)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
        )
    }
    
    private func sectionHeader(title: String) -> some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(fontColor)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 4)
    }
    
    private func sectionDescription(description: String) -> some View {
        Text(description)
            .font(.system(size: 18, weight: .regular))
            .foregroundColor(.primary)
            .multilineTextAlignment(.leading)
            .lineSpacing(4)
    }
}
