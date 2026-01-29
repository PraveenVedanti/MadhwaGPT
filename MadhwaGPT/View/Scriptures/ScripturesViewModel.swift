//
//  ScripturesViewModel.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/24/26.
//

import Foundation

struct ScriptureDetail: Identifiable, Decodable {
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


struct ChaptersResponse: Decodable {
    let sections: [ScriptureDetail]

    enum CodingKeys: String, CodingKey {
        case sandhis
        case chapters
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let sandhis = try container.decodeIfPresent([ScriptureDetail].self, forKey: .sandhis) {
            sections = sandhis
        } else if let chapters = try container.decodeIfPresent([ScriptureDetail].self, forKey: .chapters) {
            sections = chapters
        } else {
            sections = []
        }
    }
}


class ScripturesViewModel: ObservableObject {
    
    func loadScriptureDetails(scripture: Scripture) async -> [ScriptureDetail] {
        
        var returnValue: [ScriptureDetail] = []
        
        do {
            let test = try await NetworkManager.shared.fetch(urlString: scripture.chaptersURLString, type: ChaptersResponse.self)
            returnValue = test.sections
        }
        catch {
            print("Catch...")
        }
        
        return returnValue
    }
}
