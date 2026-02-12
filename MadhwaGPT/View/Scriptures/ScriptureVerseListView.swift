//
//  ScriptureVerseListView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/9/26.
//

import Foundation
import SwiftUI

struct ScriptureVerseListView: View {
    
    let scriptureChapter: ScriptureChapter
    let scripture: Scripture
    
    @State private var scriptureChapterVerseList: [ScriptureChapterVerse] = []
    @ObservedObject private var viewModel = ScriptureChapterDetailsViewModel()
    
    let backgroundColor = Color(red: 1.0, green: 0.976, blue: 0.961)
    
    var body: some View {
        VStack {
            NavigationStack {
                ScrollView {
                    LazyVStack {
                        ForEach(scriptureChapterVerseList) { verse in
                            
                            NavigationLink {
                                ScriptureVerseDetailView(
                                    verse: verse,
                                    verseList: scriptureChapterVerseList
                                )
                            } label: {
                                ScriptureChapterVerseCard(verse: verse)
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                }
                .background(backgroundColor)
            }
            .navigationTitle(scripture.title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            scriptureChapterVerseList = await viewModel.loadScriptureChapterVerseList(scripture: scripture, scriptureChapter: scriptureChapter)
        }
    }
}


struct ScriptureChapterVerseCard: View {
    let verse: ScriptureChapterVerse
    
    var body: some View {
    
        VStack(alignment: .leading, spacing: 6) {
            Text(verse.canonicalId)
                .font(.caption2)
                .fontWeight(.bold)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.2))
                .foregroundColor(.orange)
                .clipShape(Capsule())
            
            Text(verse.sanskrit ?? verse.kannada ?? "")
                .font(.headline)
                .fontWeight(.regular)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
        .padding(.horizontal, 12)
    }
}

// MARK: - Scripture chapter detail response.
struct ScriptureChapterVerseResponse: Codable {
    let verses: [ScriptureChapterVerse]
}

// MARK: - Scripture chapter detail.
struct ScriptureChapterVerse: Codable, Identifiable {
    var id: String { canonicalId }
    
    let canonicalId: String
    let chapter: Int?
    let verse: Int?
    let sandhi: Int?
    let padya: Int?
    let subVerse: Int?
    
    // Content Fields
    let sanskrit: String?
    let kannada: String?
    let transliteration: String
    let englishTranslation: String?
    let translationEnglish: String
    
    // Lists
    let suggestedQuestions: [String]
    let wordByWord: [WordDetail]?

    enum CodingKeys: String, CodingKey {
        case canonicalId = "canonical_id"
        case chapter, verse, sandhi, padya
        case subVerse = "sub_verse"
        case sanskrit, kannada, transliteration
        case englishTranslation = "english_translation"
        case translationEnglish = "translation_english"
        case suggestedQuestions = "suggested_questions"
        case wordByWord = "word_by_word"
    }
}

extension ScriptureChapterVerse: Equatable {
    static func == (lhs: ScriptureChapterVerse, rhs: ScriptureChapterVerse) -> Bool {
        lhs.canonicalId == rhs.canonicalId
    }
}

// MARK: - WordDetail
struct WordDetail: Codable {
    // Define properties based on your 'word_by_word' JSON structure
    // Example: let word: String, let meaning: String
}
