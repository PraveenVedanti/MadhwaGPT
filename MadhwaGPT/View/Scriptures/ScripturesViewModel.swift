//
//  ScripturesViewModel.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/24/26.
//

import Foundation

struct ChaptersResponse: Decodable {
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

class ScriptureViewModel: ObservableObject {
    
    @Published var scriptures: [Scripture] = []
   
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


class ScripturesViewModel: ObservableObject {
    
    func loadScriptureChapters(scripture: Scripture) async -> [ScriptureChapter] {
        
        var returnValue: [ScriptureChapter] = []
        
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
