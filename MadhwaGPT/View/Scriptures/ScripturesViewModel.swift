//
//  ScripturesViewModel.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/24/26.
//

import Foundation

struct ScriptureChaptersResponse: Decodable {
    let sections: [ScriptureChapter]

    enum CodingKeys: String, CodingKey {
        case sandhis
        case chapters
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let sandhis = try container.decodeIfPresent([ScriptureChapter].self, forKey: .sandhis) {
            sections = sandhis
        } else if let chapters = try container.decodeIfPresent([ScriptureChapter].self, forKey: .chapters) {
            sections = chapters
        } else {
            sections = []
        }
    }
}

@MainActor
class ScriptureViewModel: ObservableObject {
    
    @Published var scriptures: [Scripture] = []
    
    // Simulating data loading
    func loadScriptures() {
        
        let bhagavatGeetha = Scripture(
            title: "Bhagavatgeetha",
            description: "The song of god",
            language: "Sanskrit",
            chaptersURLString: "https://madhwagpt2.onrender.com/api/gita/chapters",
            firstMetaDataKey: "18",
            firstMetaDataValue: "Chapters",
            secondMetaDataKey: "700",
            secondMetaDataValue: "Verses"
        )
        
        let harikathamrutasara = Scripture(
            title: "Harikathamrutasara",
            description: "The Nectar of Hari's stories",
            language: "Kannada",
            chaptersURLString: "https://madhwagpt2.onrender.com/api/works/harikathamritha_sara/chapters",
            firstMetaDataKey: "33",
            firstMetaDataValue: "sandhis",
            secondMetaDataKey: "960",
            secondMetaDataValue: "Padyas"
        )
        
        scriptures.append(bhagavatGeetha)
        scriptures.append(harikathamrutasara)
    }
}


class ScriptureChaptersViewModel: ObservableObject {
    
    func loadScriptureChapters(scripture: Scripture) async -> [ScriptureChapter] {
        
        var returnValue: [ScriptureChapter] = []
        
        do {
            let test = try await NetworkManager.shared.fetch(urlString: scripture.chaptersURLString, type: ScriptureChaptersResponse.self)
            returnValue = test.sections
        }
        catch {
            print("Catch...")
        }
        
        return returnValue
    }
}


class ScriptureChapterDetailsViewModel: ObservableObject {
    
    func loadScriptureChapterVerseList(
        scripture: Scripture,
        scriptureChapter: ScriptureChapter
    ) async -> [ScriptureChapterVerse] {
        
        let url = "\(scripture.chaptersURLString)/\(scriptureChapter.number)/verses"
        
        var returnValue: [ScriptureChapterVerse] = []
        
        do {
            let test = try await NetworkManager.shared.fetch(urlString: url, type: ScriptureChapterVerseResponse.self)
            returnValue = test.verses
        }
        catch DecodingError.keyNotFound(let key, let context) {
            print("Missing key: \(key.stringValue) — \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type mismatch: \(type) — \(context.debugDescription)")
        } catch {
            print("Generic error: \(error)")
        }
        
        return returnValue
    }
}

