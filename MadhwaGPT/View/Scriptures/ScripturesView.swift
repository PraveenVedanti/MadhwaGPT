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
    @ObservedObject var viewModel = ScriptureViewModel()
    
    let scripturesList: [Scripture] = []
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                
                VStack(alignment: .leading, spacing: 16.0) {
                    
                    Spacer()
                        .frame(height: 20)
 
                    headerView
                    
                    ForEach(viewModel.scriptures) { scripture in
                        NavigationLink {
                            ScriptureDetailView(scripture: scripture)
                        } label: {
                            ScriptureCard(
                                title: scripture.title,
                                description: scripture.description,
                                language: scripture.language,
                                firstMetaDataKey: scripture.firstMetaDataKey,
                                firstMetaDataValue: scripture.firstMetaDataValue,
                                secondMetaDataKey: scripture.secondMetaDataKey,
                                secondMetaDataValue: scripture.secondMetaDataValue
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    
                    footerView
                    
                    Spacer()
                }
                .onAppear {
                    if viewModel.scriptures.isEmpty {
                        viewModel.loadScriptures()
                    }
                }
            }
            .background(backgroundColor)
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            
            Text(Strings.scripturesTitle)
                .foregroundStyle(Color.orange)
                .font(.title)
            
            Text(Strings.scripturesHeader)
                .foregroundStyle(Color.black)
                .font(.headline)
        }
        .padding(.leading, 8.0)
        .frame(maxWidth: .infinity)
    }
    
    private var footerView: some View {
        Text(Strings.scripturesSubHeader)
            .foregroundStyle(Color.gray)
            .font(.caption)
            .padding(.leading, 8.0)
            .frame(maxWidth: .infinity)
    }
}

class ScriptureViewModel: ObservableObject {
    
    @Published var scriptures: [Scripture] = []
   
    func loadScriptures() {
        
        let bhagavatGeetha = Scripture(
            title: "Bhagavatgeetha",
            description: "The song of god",
            language: "Sanskrit",
            chaptersURLString: "https://madhwagpt2.onrender.com/api/gita/chapters",
            firstMetaDataKey: "18",
            firstMetaDataValue: "Chapters",
            secondMetaDataKey: "700",
            secondMetaDataValue: "Verses"
        )
        
        let harikathamrutasara = Scripture(
            title: "Harikathamrutasara",
            description: "The Nectar of Hari's stories",
            language: "Kannada",
            chaptersURLString: "https://madhwagpt2.onrender.com/api/works/harikathamritha_sara/chapters",
            firstMetaDataKey: "33",
            firstMetaDataValue: "sandhis",
            secondMetaDataKey: "960",
            secondMetaDataValue: "Padyas"
        )
        
        scriptures.append(bhagavatGeetha)
        scriptures.append(harikathamrutasara)
    }
}

struct ScriptureCard: View {
    
    let title: String
    let description: String
    let language: String
    
    let firstMetaDataKey: String
    let firstMetaDataValue: String
    let secondMetaDataKey: String
    let secondMetaDataValue: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            titleView
            
            descriptionView
            
            Spacer()
                .frame(height: 12)
            
            metadDataView
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
    
    private var titleView: some View {
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
    }
    
    private var descriptionView: some View {
        Text(description)
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
    
    private var metadDataView: some View {
        HStack {
            Text(firstMetaDataKey)
                .fontWeight(.semibold)
                .font(.system(size: 18))
                
            Text(firstMetaDataValue)
                .foregroundColor(.gray)
                .font(.subheadline)
            
            Divider()
                .frame(height: 20)
                .background(Color.gray)
            
            Text(secondMetaDataKey)
                .fontWeight(.semibold)
                .font(.system(size: 18))

            Text(secondMetaDataValue)
                .foregroundColor(.gray)
                .font(.subheadline)
        }
    }
}

struct Scripture: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let language: String
    let chaptersURLString: String
    
    // Meta data (Ex: Chapters, Sandhis)
    let firstMetaDataKey: String
    let firstMetaDataValue: String
    let secondMetaDataKey: String
    let secondMetaDataValue: String
}


struct Strings {
    static let scripturesTitle = NSLocalizedString("Explore Sacred Texts", comment: "Scriptures page title")
    static let scripturesHeader = NSLocalizedString("Explore sacred verses with detailed meanings and translations", comment: "Scriptures page header")
    static let scripturesSubHeader = NSLocalizedString("AI-guided insights from the Madhva guru parampara tradition"
                                            , comment: "Scriptures page header")
    static let chatTitle = NSLocalizedString("Your guide to Madhvacharya's Dvaita Vedanta philosophy", comment: "Chat page title")
}
