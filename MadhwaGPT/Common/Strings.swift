//
//  Strings.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/14/26.
//

import Foundation

struct Strings {
    
    struct ChatTab {
        static let chatTitle = NSLocalizedString("Your guide to Madhvacharya's Dvaita Vedanta philosophy", comment: "Chat page title")
    }
    
    struct SettingsTab {
        static let chatLevelSheetTitle = NSLocalizedString("Select chat level", comment: "Chat level selection sheet title")
        static let chatThemeSheetTitle = NSLocalizedString("Select theme", comment: "Chat theme selection sheet title")
        static let userLevelSectionTitle = NSLocalizedString("User Level", comment: "User level section title")
        static let appearanceSectionTitle = NSLocalizedString("Appearance", comment: "Appearance section title")
        static let settingsTitle = NSLocalizedString("Settings", comment: "Settings page title")
    }
    
    static let scripturesTitle = NSLocalizedString("Explore Sacred Texts", comment: "Scriptures page title")
    static let scripturesHeader = NSLocalizedString("Explore sacred verses with detailed meanings and translations", comment: "Scriptures page header")
    static let scripturesSubHeader = NSLocalizedString("AI-guided insights from the Madhva guru parampara tradition"
                                            , comment: "Scriptures page header")
   
    static let welcomeHeaderTitle = NSLocalizedString("Your guide to Madhvacharya's Dvaita Vedanta philosophy", comment: "welcome header title")
}
