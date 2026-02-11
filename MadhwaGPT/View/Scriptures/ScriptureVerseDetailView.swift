//
//  ScriptureVerseDetailView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/10/26.
//

import Foundation
import SwiftUI

enum ScriptureVerseDetailTab: String, CaseIterable {
    case verse = "Verse"
    case ai = "Ask AI"
}

struct ScriptureVerseDetailView: View {
    let verse: ScriptureChapterVerse
    
    @State private var currentTab: ScriptureVerseDetailTab = .verse
    
    let tabs = ScriptureVerseDetailTab.allCases
    
    init(verse: ScriptureChapterVerse) {
        self.verse = verse
    }
    
    var body: some View {
        SlidingTabView(
            tabs: tabs,
            selectedTab: $currentTab,
            activeColor: .orange,
            titleMapper: { $0.rawValue }
        ) { tab in
           
            switch tab {
            case .verse:
                Text("Verse")
            case .ai:
                Text("AI Tab")
            }
        }
    }
}
