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
    
    @ObservedObject private var viewModel =  ScriptureChaptersViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(scriptureChapters) { scriptureChapter in
                        NavigationLink {
                            ScriptureVerseListView(
                                scriptureChapter: scriptureChapter,
                                scripture: scripture
                            )
                        } label: {
                            ScriptureChapterCard(scriptureChapter: scriptureChapter)
                        }
                    }
                }
            }
            .background(Color(.systemBackground))
        }
        .task {
            scriptureChapters = await viewModel.loadScriptureChapters(scripture: scripture)
        }
    }
}

struct ScriptureChapterCard: View {
    
    let scriptureChapter: ScriptureChapter
    
    @Environment(\.colorScheme) var colorScheme
   
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            HStack {
                mainTitleView
                
                Spacer()
                
                Image(systemName: "arrow.right")
            }
           
            transliteratedView
            
            descriptionView
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackgroundStyle()
        .padding(.horizontal, 12)
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

struct ScriptureChapter: Identifiable, Decodable {
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
