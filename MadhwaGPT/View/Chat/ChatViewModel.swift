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
}

struct ChatRequestBody {
    
}

class ChatViewModel: ObservableObject {
    
    @Published var selectedChatLevel: ChatLevel?
    
    @Published var initialSuggestions: [InitialChatSuggestions] = []
    
    // This is hard-coded way to load initial suggestions.
    func loadChatSuggestions() {
        let first = InitialChatSuggestions(
            suggestion: "Explain the five-fold difference (Pancha-bheda)"
        )
        let second = InitialChatSuggestions(
            suggestion: "In 'कर्मण्येवाधिकारस्ते' (Gita 2.47), what is Krishna teaching Arjuna?"
        )
        
        let third = InitialChatSuggestions(
            suggestion: "What is the hierarchy among souls according to Madhvacharya?"
        )
        
        let fourth = InitialChatSuggestions(
            suggestion: "ಭಗವದ್ಗೀತೆಯ ಪ್ರಕಾರ ಭಕ್ತಿ ಎಂದರೇನು?"
        )
        
        let fifth = InitialChatSuggestions(suggestion: "How does Harikathāmṛtasāra explain creation, sustenance, and dissolution of the universe?")
        
        let sixth = InitialChatSuggestions(
            suggestion: "नासतो विद्यते भावो नाभावो विद्यते सतः। उभयोरपि दृष्टोऽन्तस्त्वनयोस्तत्त्वदर्शिभिः॥ - Explain"
        )
        
        initialSuggestions.append(first)
        initialSuggestions.append(second)
        initialSuggestions.append(third)
        initialSuggestions.append(fourth)
        initialSuggestions.append(fifth)
        initialSuggestions.append(sixth)
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
