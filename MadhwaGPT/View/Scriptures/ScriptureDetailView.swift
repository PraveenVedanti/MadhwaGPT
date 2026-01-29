//
//  ScriptureDetailView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/23/26.
//

import Foundation
import SwiftUI

struct ScriptureDetailView: View {
    
    let scripture: Scripture
    let backgroundColor = Color(red: 1.0, green: 0.976, blue: 0.961)
    
    @State private var scriptureDetails: [ScriptureDetail] = []
    
    @ObservedObject private var viewModel =  ScripturesViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16.0) {
                    ForEach(scriptureDetails) { scriptureDetail in
                        NavigationLink {
                            Text("Hello")
                        } label: {
                            ScriptureDetailCard(scriptureDetail: scriptureDetail)
                        }
                    }
                }
            }
            .background(backgroundColor)
        }
        .task {
            scriptureDetails = await viewModel.loadScriptureDetails(scripture: scripture)
        }
        .navigationTitle(scripture.title)
    }
}


struct ScriptureDetailCard: View {
    
    let scriptureDetail: ScriptureDetail
   
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            mainTitleView
            
            transliteratedView
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
    
    @ViewBuilder
    private var mainTitleView: some View {
        if let kannadaName = scriptureDetail.kannadaName {
            Text(kannadaName)
                .font(.headline)
                .foregroundColor(.black)
        }
        
        if let sanskritName = scriptureDetail.sanskritName {
            Text(sanskritName)
                .font(.headline)
                .foregroundColor(.black)
        }
    }
    
    private var transliteratedView: some View {
        Text(scriptureDetail.transliteratedName)
            .font(.subheadline)
            .italic()
            .foregroundColor(.secondary)
    }
}
