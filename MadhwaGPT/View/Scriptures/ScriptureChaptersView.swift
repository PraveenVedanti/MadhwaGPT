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
    
    @StateObject private var viewModel =  ScriptureChaptersViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            ForEach(scriptureChapters) { chapter in
                NavigationLink {
                    ScriptureVerseListView(
                        scriptureChapter: chapter,
                        scripture: scripture
                    )
                    
                } label: {
                    ScriptureChapterCard(scriptureChapter: chapter)
                }
                .listRowBackground(colorScheme == .light ? Color(.systemBackground) : Color(uiColor: .secondarySystemBackground))
                .listRowSeparator(.hidden)
            }
            .padding(.horizontal, 12)
        }
        .scrollContentBackground(colorScheme == .dark ? .hidden : .visible)
        .background(colorScheme == .light ? Color(.systemBackground) : Color(uiColor: .secondarySystemBackground))
        .listStyle(.plain)
        .task(id: scripture.id) {
            scriptureChapters = await viewModel.loadScriptureChapters(scripture: scripture)
        }
    }
}

struct ScriptureChapterCard: View {
    
    let scriptureChapter: ScriptureChapter
    
    @Environment(\.colorScheme) var colorScheme
   
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            
            mainTitleView
           
            transliteratedView
            
            descriptionView
        }
        .padding(.vertical, 2)
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
