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
                VStack(alignment: .leading, spacing: 16) {
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
        
        VStack(alignment: .leading, spacing: 2) {
            
            HStack {
                mainTitleView
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundStyle(textColor)
            }

            transliteratedView
            
            descriptionView
            
            Spacer()
            Spacer()
            testView
            
            Spacer()
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Continue reading")
                }
                .buttonStyle(.bordered)
                
            }
        }
        .onAppear {
            setThemes()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackgroundStyle(backroundColor: backgroundColor, textColor: textColor)
        .padding(.horizontal, 12)
    }
    
    private func setThemes() {
        textColor =  ColorTokens.setTextColor(theme: settingsViewModel.selectedChatTheme)
        backgroundColor = ColorTokens.setBackgroundColor(theme: settingsViewModel.selectedChatTheme)
    }
    
    @ViewBuilder
    private var mainTitleView: some View {
        if let kannadaName = scriptureChapter.kannadaName {
            Text(kannadaName)
                .font(.custom("DevanagariSangamMN-Bold", size: 18))
                .foregroundColor(.primary)
        }
        
        if let sanskritName = scriptureChapter.sanskritName {
            Text(sanskritName)
                .font(.custom("DevanagariSangamMN-Bold", size: 18))
                .foregroundColor(.primary)
        }
    }
    
    private var transliteratedView: some View {
        Text(scriptureChapter.transliteratedName)
            .font(.custom("Iowan Old Style", size: 18))
            .italic()
            .foregroundColor(.secondary)
    }
    
    private var descriptionView: some View {
        Text(scriptureChapter.englishName)
            .font(.custom("Iowan Old Style", size: 16))
            .fontWeight(colorScheme == .light ? .semibold : .regular)
            .foregroundColor(textColor)
    }
    
    private var testView: some View {
        HStack {
            
            Label {
                Text("verses")
            } icon: {
                Image(systemName: "book")
            }
            
            Spacer()
            
            Label {
                Text("~28 min")
            } icon: {
                Image(systemName: "clock")
            }
        }
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
