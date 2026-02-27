//
//  ScriptureChaptersView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/30/26.
//

import Foundation
import SwiftUI
   
struct ScriptureChaptersView: View {
    
    let scripture: Scripture
    
    @State private var scriptureChapters: [ScriptureChapter] = []
    
    // View models.
    @StateObject private var viewModel =  ScriptureChaptersViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
   
    @Environment(\.colorScheme) var colorScheme
    
    // Background color of the view.
    @State private var backgroundColor: Color = Color(.systemBackground)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(scriptureChapters) { chapter in
                        NavigationLink {
                            ScriptureVerseListView(
                                scriptureChapter: chapter,
                                scripture: scripture
                            )
                            
                        } label: {
                            ScriptureChapterCard(scriptureChapter: chapter)
                        }
                    }
                }
            }
        }
        .onAppear {
            setBGColor()
        }
        .background(backgroundColor)
        .task(id: scripture.id) {
            scriptureChapters = await viewModel.loadScriptureChapters(scripture: scripture)
        }
    }
    
    private func setBGColor() {
        backgroundColor =  ColorTokens.setBackgroundColor(theme: settingsViewModel.selectedChatTheme)
    }
}

struct ScriptureChapterCard: View {
    
    let scriptureChapter: ScriptureChapter
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var textColor: Color = .primary
    @State private var backgroundColor: Color = .primary
    
    @StateObject private var settingsViewModel = SettingsViewModel()
   
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            mainTitleView
            
            transliteratedView
            
            descriptionView
        }
        .onAppear {
            setThemes()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func setThemes() {
        textColor =  ColorTokens.setTextColor(theme: settingsViewModel.selectedChatTheme)
        backgroundColor = ColorTokens.setBackgroundColor(theme: settingsViewModel.selectedChatTheme)
    }
    
    @ViewBuilder
    private var mainTitleView: some View {
        if let kannadaName = scriptureChapter.kannadaName {
            Text(kannadaName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(textColor)
        }
        
        if let sanskritName = scriptureChapter.sanskritName {
            Text(sanskritName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(textColor)
        }
    }
    
    private var transliteratedView: some View {
        Text(scriptureChapter.transliteratedName)
            .font(.system(size: 16, weight: .bold, design: .serif))
            .font(.headline)
            .italic()
            .foregroundColor(.primary)
    }
    
    private var descriptionView: some View {
        Text(scriptureChapter.englishName)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.primary.opacity(0.4))
            .padding(.bottom, 4)
    }
    
    private var testView: some View {
        Label {
            Text("6/30")
                .font(.footnote)
        } icon: {
            Image(systemName: "book")
        }
        .foregroundColor(.secondary)
    }
}

struct ScriptureChapter: Identifiable, Decodable, Hashable {
    var id = UUID()
    let number: Int
    let sanskritName: String?
    let kannadaName: String?
    let englishName: String
    let transliteratedName: String
    let description: String?
    let verseCount: Int
    
    enum CodingKeys: String, CodingKey {
        case number
        case sanskritName = "sanskrit_name"
        case kannadaName = "kannada_name"
        case englishName = "english_name"
        case transliteratedName = "transliterated_name"
        case description
        case verseCount = "verse_count"
    }
}
