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
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            ForEach(scriptureChapterVerseList) { verse in
                
                NavigationLink {
                    ScriptureVerseDetailView(
                        verse: verse,
                        verseList: scriptureChapterVerseList
                    )
                } label: {
                    ScriptureChapterVerseCard(verse: verse)
                }
                .listRowBackground(Color("SaffronCardBackround"))
            }
            .padding(.horizontal, 12)
        }
        .navigationTitle(scriptureChapter.sanskritName ?? scriptureChapter.kannadaName ?? "Unknown")
        .navigationBarTitleDisplayMode(.large)
        .scrollContentBackground(.hidden)
        .background(Color("SaffronBackround"))
        .listStyle(.insetGrouped)
        .task {
            scriptureChapterVerseList = await viewModel.loadScriptureChapterVerseList(scripture: scripture, scriptureChapter: scriptureChapter)
        }
    }
}


struct ScriptureChapterVerseCard: View {
    let verse: ScriptureChapterVerse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(titleView())
                .font(.system(.caption, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(.orange)
            
            if let kannadaVerse = verse.kannada {
                Text(kannadaVerse)
                    .font(.system(.body, design: .serif))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
            }
            
            if let sanskritVerse = verse.sanskrit {
                Text(sanskritVerse)
                    .font(.system(.body, design: .serif))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
            }
        }
        .padding(.vertical, 2)
    }
    
    private func titleView() -> String {
        var chapter: Int = 0
        var subChapter: Int = 0
        if let _ = verse.kannada {
            chapter = verse.sandhi ?? 0
            subChapter = verse.padya ?? 0
        }
        
        if let _ = verse.sanskrit {
            chapter = verse.chapter ?? 0
            subChapter = verse.verse ?? 0
        }
        return "\(chapter).\(subChapter)"
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
