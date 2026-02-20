//
//  SettingsViewModel.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/18/26.
//

import Foundation
import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    
    @Published var chatLevels: [ChatLevel] = []
    @Published var chatThemes: [ChatTheme] = []
    
    // Store the ID of the selected level
    @AppStorage("selectedChatTheme") var selectedChatTheme: String = ""
    
    func loadChatLevels() {
        let beginner = ChatLevel(title: "Beginner", description: "Simple explanations")
        let intermediate = ChatLevel(title: "Intermediate", description: "Balanced detail")
        let scholar = ChatLevel(title: "Scholar", description: "Advanced terminology")
        
        chatLevels.append(beginner)
        chatLevels.append(intermediate)
        chatLevels.append(scholar)
    }
    
    func loadChatThemes() {
        let purple = ChatTheme(title: "NotebookLM Purple", description: "Modern purple theme", color: Color.purple)
        let saffron = ChatTheme(title: "Saffron Wisdom", description: "Traditional Indian spiritual theme", color: Color.orange)
        let templeGold = ChatTheme(title: "Temple Gold", description: "Rich traditional temple palette", color: Color.brown.opacity(0.6))
        let roseGold = ChatTheme(title: "Ancient Rose Gold", description: "Premium rose-gold with parchment warmth", color: Color.pink.opacity(0.4))
        let teal = ChatTheme(title: "Scholarly Teal", description: "Calm academic theme", color: Color.teal.opacity(0.5))
        let manuscript = ChatTheme(title: "Ancient Manuscript", description: "Warm parchment theme", color: Color.brown)
        let green = ChatTheme(title: "Sage Green", description: "Natural wisdom theme", color: Color.green.opacity(0.5))
        let noTheme = ChatTheme(title: "Default (No color theme)", description: "No theming applied", color: Color.primary)
        
        chatThemes.append(purple)
        chatThemes.append(saffron)
        chatThemes.append(templeGold)
        chatThemes.append(roseGold)
        chatThemes.append(teal)
        chatThemes.append(manuscript)
        chatThemes.append(green)
        chatThemes.append(noTheme)
    }
    
    // Helper to get the actual Level object based on the ID
    var selectedLevel: ChatTheme? {
        chatThemes.first { $0.id == selectedChatTheme }
    }
}


struct ChatLevel: Identifiable {
    var id: String { title }
    let title: String
    let description: String
}

struct ChatTheme: Identifiable {
    var id: String { title }
    let title: String
    let description: String
    let color: Color
}

