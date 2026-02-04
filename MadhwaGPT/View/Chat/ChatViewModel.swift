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

struct ChatRequestBody {
    
}

class ChatViewModel: ObservableObject {
    
    @Published var chatLevels: [ChatLevel] = []
    @Published var selectedChatLevel: ChatLevel?
    
    func loadChatTypes()  {
        let beginner = ChatLevel(title: "👶 Beginner")
        let intermediate = ChatLevel(title: "📘 Intermediate")
        let advanced = ChatLevel(title: "🎓 Advanced")
        
        chatLevels.append(beginner)
        chatLevels.append(intermediate)
        chatLevels.append(advanced)
        
        // Select the first category by default.
        if self.selectedChatLevel == nil, let first = chatLevels.first {
            self.selectedChatLevel = first
        }
    }
    
    func loadSuggestions() async {
        
    }
    
    func queryQuestion(_ query: String) async throws -> String {
        do {
            let answer = try await NetworkManager.shared.askQuestion(question: query)
            return answer
        } catch {
            print("Error:", error.localizedDescription)
            return ""
        }
    }
}
