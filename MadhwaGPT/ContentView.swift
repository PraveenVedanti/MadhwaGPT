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
    
    var iconFill: String {
        switch self {
        case .chat: return "message.fill"
        case .scriptures: return "book.fill"
        case .favourites: return "heart.fill"
        case .settings: return "gear.circle.fill"
        }
    }
}


struct ContentView: View {
    @State private var selectedTab: AppTab = .chat

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {

                NavigationStack {
                    ChatView()
                }
                .tag(AppTab.chat)

                NavigationStack {
                    ScripturesView()
                }
                .tag(AppTab.scriptures)

                NavigationStack {
                    FavouritesView()
                }
                .tag(AppTab.favourites)

                NavigationStack {
                    SettingsView()
                }
                .tag(AppTab.settings)
            }
            .toolbar(.hidden, for: .tabBar)

            VStack {
                 Spacer()
                TabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct TabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack {
            ForEach(AppTab.allCases, id: \.self) { tab in
                tabButton(tab)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.orange.opacity(0.1))
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    private func tabButton(_ tab: AppTab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                
                Image(systemName: selectedTab == tab ? tab.iconFill : tab.icon)
                
                Text(tab.title)
                    .font(.caption2)
            }
            .foregroundColor(
                selectedTab == tab ? .orange : .gray
            )
            .frame(maxWidth: .infinity)
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
