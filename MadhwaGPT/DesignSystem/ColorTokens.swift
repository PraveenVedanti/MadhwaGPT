//
//  ColorTokens.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/20/26.
//

import Foundation
import SwiftUI

struct ColorTokens {

    static func setBackgroundColor(theme: String) -> Color {
        switch theme {
        case "Ancient Manuscript":
            return Color("AncientManuscript")
        case "Saffron Wisdom":
            return Color("SaffronWisdom")
        case "Sage Green":
            return Color("SageGreen")
        case "Scholarly Teal":
            return Color("ScholarlyTeal")
        case "Ancient Rose Gold":
            return Color("AncientRoseGold")
        case "NotebookLM Purple":
            return Color("NotebookLMPurple")
        case "Temple Gold":
            return Color("TempleGold")
        default:
            return Color(uiColor: .secondarySystemBackground)
        }
    }
    
    static func setTextColor(theme: String) -> Color {
        switch theme {
        case "Ancient Manuscript":
            return Color.brown
        case "Saffron Wisdom":
            return Color.orange
        case "Sage Green":
            return Color.green
        case "Scholarly Teal":
            return Color.teal
        case "Ancient Rose Gold":
            return Color.ancientRoseGoldText
        case "NotebookLM Purple":
            return Color.notebookLMPurpleText
        case "Temple Gold":
            return Color.templeGoldText
        default:
            return Color.orange
        }
    }
}


extension Color {
    static let notebookLMPurpleText = Color(red: 164/255, green: 147/255, blue: 225/255)
    static let ancientRoseGoldText = Color(red: 210/255, green: 180/255, blue: 176/255)
    static let templeGoldText = Color(red: 211/255, green: 174/255, blue: 111/255)
}
