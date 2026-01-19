//
//  ScripturesView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/17/26.
//

import Foundation
import SwiftUI

struct ScripturesView: View {
    
    let backgroundColor = Color(red: 1.0, green: 0.976, blue: 0.961)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            headerView
            
            ScriptureCard(title: "Bhagavatgeetha", description: "The song of god", language: "Sanskrit")
            ScriptureCard(title: "Harikathamrutasara", description: "The Nectar of Hari's stories", language: "Kannada")
            
            Spacer()
        }
        .background(backgroundColor)
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            
            Text(Strings.title)
                .foregroundStyle(Color.orange)
                .font(.title)
            
            Text(Strings.header)
                .foregroundStyle(Color.black)
                .font(.headline)
            
            Text(Strings.subHeader)
                .foregroundStyle(Color.gray)
                .font(.caption)
        }
        .padding(.leading, 8.0)
        .frame(maxWidth: .infinity)
    }
}

struct ScriptureCard: View {
    
    let title: String
    let description: String
    let language: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            HStack {
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Text(language)
                    .font(.subheadline)
                    .foregroundColor(.orange)
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.gray.opacity(0.4))
            }
            
        
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
        .padding(.horizontal, 12)
    }
}



struct Strings {
    
    static let title = NSLocalizedString("Explore Sacred Texts (Preview)", comment: "Scriptures page title")
    static let header = NSLocalizedString("Explore sacred verses with detailed meanings and translations", comment: "Scriptures page header")
    static let subHeader = NSLocalizedString("AI-guided insights from the Madhva guru parampara tradition"
                                             , comment: "Scriptures page header")
}
