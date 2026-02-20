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
            ScriptureChapterVerseView(verse: selectedVerse)
                .background(Color("SaffronCardBackround"))
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

//struct ScriptureChapterVerseDescriptionCard: View {
//    
//    let verse: ScriptureChapterVerse
//    
//    init(verse: ScriptureChapterVerse) {
//        self.verse = verse
//    }
//    
//    var body: some View {
//        
//    }
//}


struct ScriptureChapterVerseView: View {
    
    let verse: ScriptureChapterVerse
    var words: [WordDetail] = []
    
    @Environment(\.colorScheme) var colorScheme
    
    init(verse: ScriptureChapterVerse) {
        self.verse = verse
        self.words = verse.wordByWord ?? []
    }
    
    var body: some View {
        
        List {
            
            // Main verse section
            Section {
                if let sanskrit = verse.sanskrit {
                    sectionDescription(description: sanskrit, color: .primary, font: "DevanagariSangamMN")
                }
                
                if let kannada = verse.kannada {
                    sectionDescription(description: kannada, color: .primary, font: "KannadaSangamMN")
                }
            } header: {
                if let _ = verse.sanskrit {
                    sectionHeader(title: "SANSKRIT (DEVANAGARI)", color: .secondary, font: "Iowan Old Style")
                }
                
                if let _ = verse.kannada {
                    sectionHeader(title: "KANNADA", color: .secondary, font: "Iowan Old Style")
                }
            }
            .listRowBackground(Color(.systemBackground))
            .listRowSeparator(.hidden)
            
            // Transliteration section
            Section {
                Text(verse.transliteration)
                    .font(.system(.body, design: .serif))
                    .italic()
                    .foregroundColor(.secondary)
            } header: {
                sectionHeader(title: "TRANSLITERATION", color: .secondary, font: "Iowan Old Style")
            }
            .listRowBackground(Color(.systemBackground))
            .listRowSeparator(.hidden)

            // English translation section
            Section {
                englishTranslationCard
            } header: {
                sectionHeader(title: "ENGLISH TRANSLATION", color: .secondary, font: "Iowan Old Style")
            }
            .listRowBackground(colorScheme == .light ? Color(.systemBackground) : Color(uiColor: .secondarySystemBackground))
            .listRowSeparator(.hidden)
        
            // Word by word section
            Section {
                wordByWordCard
            } header: {
                sectionHeader(title: "WORD-BY-WORD MEANINGS", color: .secondary, font: "Iowan Old Style")
            }
            .listRowBackground(Color(.systemBackground))
            .listRowSeparator(.hidden)
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(colorScheme == .dark ? .hidden : .visible)
        .background(colorScheme == .light ? Color(.systemBackground) : Color(uiColor: .secondarySystemBackground))
    }
    
    private var wordByWordCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(words) { word in
                HStack(alignment: .top, spacing: 16) {
                    // The Term
                    Text(word.word)
                        .font(.custom("Iowan Old Style", size: 18))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(2)
                        .frame(width: 110, alignment: .leading)
                    
                    // The Meaning
                    Text(word.meaning)
                        .font(.custom("Iowan Old Style", size: 18))
                        .foregroundColor(.secondary)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                if word.id != words.last?.id {
                    Divider()
                        .padding(.leading, 126)
                        .opacity(0.6)
                }
            }
        }
    }
    
    private var englishTranslationCard: some View {
        sectionDescription(description: verse.translationEnglish, color: .primary.opacity(0.6), font: "Iowan Old Style")
    }
    
    private func sectionHeader(title: String, color: Color, font: String) -> some View {
        Text(title)
            .font(.custom(font, size: 18))
            .kerning(1)
            .foregroundColor(color)
    }
    
    private func sectionDescription(description: String, color: Color, font: String) -> some View {
        Text(description)
            .font(.custom(font, size: 20))
            .foregroundColor(.primary)
            .multilineTextAlignment(.leading)
            .lineSpacing(2)
    }
}

// MARK: - AI Insights view.

struct ScriptureAIInsightView: View {
    var body: some View {
        Text("AI Tab")
    }
}
