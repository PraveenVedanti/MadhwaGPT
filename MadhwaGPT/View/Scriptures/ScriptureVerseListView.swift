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
                .background(Color(.systemBackground))
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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
    
        VStack(alignment: .leading, spacing: 6) {
            Text(verse.canonicalId)
                .font(.caption2)
                .fontWeight(.bold)
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
                .foregroundColor(.orange)
            
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
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
        .shadow(
            color: Color.black.opacity(0.05),
            radius: 8,
            x: 0,
            y: 4
        )
        .padding(.horizontal, 12)
    }
}

// MARK: - Scripture chapter detail response.
struct ScriptureChapterVerseResponse: Decodable {
    let verses: [ScriptureChapterVerse]
}

// MARK: - Scripture chapter detail.
struct ScriptureChapterVerse: Decodable, Identifiable {
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
//struct WordDetail: Codable, Identifiable, Equatable {
//    let id = UUID()
//    let term: String
//    let meaning: String
//    
//    enum CodingKeys: String, CodingKey {
//        case term, meaning
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.term = try container.decode(String.self, forKey: .term)
//        self.meaning = try container.decode(String.self, forKey: .meaning)
//    }
//}


// MARK: - WordDetail
struct WordDetail: Decodable, Identifiable, Equatable {
    var id: String { word }
    let word: String
    let meaning: String
    
    enum CodingKeys: String, CodingKey {
        case word, term, meaning
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle both "word" and "term" keys
        if let wordValue = try? container.decode(String.self, forKey: .word) {
            self.word = wordValue
        } else if let termValue = try? container.decode(String.self, forKey: .term) {
            self.word = termValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .word, in: container, debugDescription: "No word or term key found")
        }
        
        self.meaning = try container.decode(String.self, forKey: .meaning)
    }
}
