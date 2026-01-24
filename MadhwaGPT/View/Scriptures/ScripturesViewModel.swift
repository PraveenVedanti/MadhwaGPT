//
//  ScripturesViewModel.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/24/26.
//

import Foundation

struct ScriptureDetail: Identifiable {
    let id = UUID()
    let number: Int
    let sanskritName: String
    let englishName: String
    let transliteratedName: String
    let description: String
    let verseCount: Int
}

class ScripturesViewModel: ObservableObject {
    
    func loadScriptureDetails(scripture: Scripture) async {
        
    }
}
