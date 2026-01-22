//
//  ContentView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/17/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    var body: some View {
        
        TabView {
           
            NavigationStack {
                ChatView()
            }
            .tabItem {
                Label("Chat", systemImage: "message")
            }
            
            NavigationStack {
                ScripturesView()
            }
            .tabItem {
                Label("Scriptures", systemImage: "book")
            }
            
            NavigationStack {
                FavouritesView()
            }
            .tabItem {
                Label("Favourites", systemImage: "heart")
            }
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .tint(Color.orange)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
