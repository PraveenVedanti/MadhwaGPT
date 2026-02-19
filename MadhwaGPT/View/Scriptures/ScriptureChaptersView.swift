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
                .listRowBackground(Color("SaffronCardBackround"))
            }
            .padding(.horizontal, 12)
        }
        .task(id: scripture.id) {
            scriptureChapters = await viewModel.loadScriptureChapters(scripture: scripture)
        }
    }
}

struct ScriptureChaptersView1: View {
    let scripture: Scripture
    @StateObject private var viewModel = ScriptureChaptersViewModel()
    @State private var scriptureChapters: [ScriptureChapter] = []

    var body: some View {
        Group {
            if scriptureChapters.isEmpty {
                // This helps us see if the view is actually alive
                ContentUnavailableView("Loading...", systemImage: "book.pages")
            } else {
                List {
                    ForEach(scriptureChapters) { chapter in
                        NavigationLink(value: chapter) {
                            ScriptureChapterCard(scriptureChapter: chapter)
                        }
                        .listRowBackground(Color("SaffronCardBackground"))
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle(scripture.title)
        .scrollContentBackground(.hidden)
        .background(Color("SaffronBackground"))
        .task(id: scripture.id) {
            // Debug: Print to console to see if this even runs
            print("Fetching chapters for \(scripture.title)")
            let data = await viewModel.loadScriptureChapters(scripture: scripture)
            self.scriptureChapters = data
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
                .font(.headline)
                .foregroundColor(.primary)
        }
        
        if let sanskritName = scriptureChapter.sanskritName {
            Text(sanskritName)
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
    
    private var transliteratedView: some View {
        Text(scriptureChapter.transliteratedName)
            .font(.subheadline)
            .italic()
            .foregroundColor(.secondary)
    }
    
    private var descriptionView: some View {
        Text(scriptureChapter.englishName)
            .font(.footnote)
            .foregroundColor(.orange.opacity(0.8))
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
