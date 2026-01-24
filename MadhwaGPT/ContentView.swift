//
//  ContentView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/17/26.
//

import SwiftUI
import SwiftData

enum AppTab: CaseIterable {
    case chat, scriptures, favourites, settings

    var title: String {
        switch self {
        case .chat: return "Chat"
        case .scriptures: return "Scriptures"
        case .favourites: return "Favourites"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .chat: return "message"
        case .scriptures: return "book"
        case .favourites: return "heart"
        case .settings: return "gear"
        }
    }
}


import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ChatView()
                .tabItem {
                    Label(AppTab.chat.title, systemImage: AppTab.chat.icon)
                }
            
            ScripturesView()
                .tabItem {
                    Label(AppTab.scriptures.title, systemImage: AppTab.scriptures.icon)
                }
            
            FavouritesView()
                .tabItem {
                    Label(AppTab.favourites.title, systemImage: AppTab.favourites.icon)
                }
            
            SettingsView()
                .tabItem {
                    Label(AppTab.settings.title, systemImage: AppTab.settings.icon)
                }
        }
        .tint(Color.orange)
    }
}



#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
