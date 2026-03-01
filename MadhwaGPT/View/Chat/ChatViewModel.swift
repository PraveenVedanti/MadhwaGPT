//
//  ChatViewModel.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/18/26.
//

import Foundation



struct InitialChatSuggestions: Identifiable {
    var id = UUID()
    var suggestion: String
    var suggestionFont: String
}

struct ChatRequestBody {
    
}

class ChatViewModel: ObservableObject {
    
    @Published var selectedChatLevel: ChatLevel?
    
    @Published var chatSuggestions: [InitialChatSuggestions] = []
    @Published var initialChatSuggestions: [InitialChatSuggestions] = []
    
    // This is hard-coded way to load initial suggestions.
    func loadChatSuggestions() {
        let first = InitialChatSuggestions(
            suggestion: "Explain the five-fold difference (Pancha-bheda)",
            suggestionFont: "Iowan Old Style"
        )
        let second = InitialChatSuggestions(
            suggestion: "In 'कर्मण्येवाधिकारस्ते' (Gita 2.47), what is Krishna teaching Arjuna?",
            suggestionFont: "Iowan Old Style"
        )
        
        let third = InitialChatSuggestions(
            suggestion: "What is the hierarchy among souls according to Madhvacharya?",
            suggestionFont: "Iowan Old Style"
        )
        
        let fourth = InitialChatSuggestions(
            suggestion: "ಭಗವದ್ಗೀತೆಯ ಪ್ರಕಾರ ಭಕ್ತಿ ಎಂದರೇನು?",
            suggestionFont: "KannadaSangamMN"
        )
        
        let fifth = InitialChatSuggestions(suggestion: "How does Harikathāmṛtasāra explain creation, sustenance, and dissolution of the universe?",
            suggestionFont: "Iowan Old Style"
        )
        
        let sixth = InitialChatSuggestions(
            suggestion: "नासतो विद्यते भावो नाभावो विद्यते सतः। उभयोरपि दृष्टोऽन्तस्त्वनयोस्तत्त्वदर्शिभिः॥ - Explain",
            suggestionFont: "DevanagariSangamMN"
        )
        
        chatSuggestions.append(first)
        chatSuggestions.append(second)
        chatSuggestions.append(third)
        chatSuggestions.append(fourth)
        chatSuggestions.append(fifth)
        chatSuggestions.append(sixth)
        
        // Initial chat suggestions.
        initialChatSuggestions.append(second)
        initialChatSuggestions.append(third)
        initialChatSuggestions.append(fourth)
    }
    
    func queryQuestion(_ query: String, persona: String) async throws -> String {
        do {
            let answer = try await NetworkManager.shared.askQuestion(question: query, persona: persona)
            return answer
        } catch {
            print("Error:", error.localizedDescription)
            return ""
        }
    }
}
