//
//  ChatViewModel.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/18/26.
//

import Foundation

struct ChatLevel: Identifiable {
    var id = UUID()
    let title: String
}

class ChatViewModel: ObservableObject {
    
    @Published var chatLevels: [ChatLevel] = []
    
    func loadChatTypes()  {
        let beginner = ChatLevel(title: "👶 Beginner")
        let intermediate = ChatLevel(title: "📘 Intermediate")
        let advanced = ChatLevel(title: "🎓 Advanced")
        
        chatLevels.append(beginner)
        chatLevels.append(intermediate)
        chatLevels.append(advanced)
    }
    
    func loadSuggestions() async {
        
    }
}
