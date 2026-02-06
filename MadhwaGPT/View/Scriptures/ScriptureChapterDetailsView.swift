//
//  ScriptureChapterDetailsView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/30/26.
//

import Foundation
import SwiftUI

struct ScriptureChapterDetailsView: View {
    
    let scriptureChapter: ScriptureChapter
    let scripture: Scripture
    
    @State private var scriptureChapterDetails: [ScriptureChapterDetail] = []
    @ObservedObject private var viewModel = ScriptureChapterDetailsViewModel()
    

    var body: some View {
        VStack {
            NavigationStack {
                ScrollView {
                    ForEach(scriptureChapterDetails) { scriptureChapterDetail in
                        ScriptureChapterDetailCard()
                    }
                }
            }
        }
        .task {
            scriptureChapterDetails = await viewModel.loadScriptureChapterDetails(scripture: scripture, scriptureChapter: scriptureChapter)
        }
        
    }
}


struct ScriptureChapterDetailCard: View {
    

    
    var body: some View {
        Text("Hekllo out")
        
    }
}


struct ScriptureChapterDetail: Identifiable, Codable, Hashable {
    var id = UUID()
    
    let verse: Int
    var sanskritText: String
    let transliteration: String
    let englishTranslation: String
    
    enum CodingKeys: String, CodingKey {
        case verse
        case sanskritText = "sanskrit"
        case transliteration
        case englishTranslation = "english_translation"
    }
}
