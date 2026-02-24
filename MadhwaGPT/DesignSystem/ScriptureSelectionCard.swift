//
//  ScriptureSelectionCard.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/15/26.
//

import Foundation
import SwiftUI

struct ScriptureSelectionCard: View {
    
    let scripture: Scripture
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var textColor: Color = .primary
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        HStack(spacing: 12) {
            
            checkMarkView
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(scripture.title)
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                }
                
                Text(scripture.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 24) {
                    
                    HStack(spacing: 8) {
                        MetadataUnit(label: scripture.firstMetaDataValue, value: scripture.firstMetaDataKey)
                        
                        Circle()
                            .fill(Color.secondary.opacity(0.8))
                            .frame(width: 8, height: 8)
                       
                        MetadataUnit(label: scripture.secondMetaDataKey, value: scripture.secondMetaDataValue)
                    }
                    
                    languageView
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            setThemes()
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
    
    private var checkMarkView: some View {
        ZStack {
            Circle()
                .stroke(isSelected ? textColor : Color.secondary.opacity(0.3), lineWidth: 1)
                .frame(width: 16, height: 16)
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(textColor)
            }
        }
    }
    
    private var languageView: some View {
        Text(scripture.language)
            .font(.system(size: 10, weight: .black))
            .textCase(.uppercase)
            .foregroundStyle(textColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(textColor.opacity(0.12))
            )
            .overlay(
                Capsule()
                    .stroke(textColor.opacity(0.25), lineWidth: 1)
            )
    }
    
    private var metadataView: some View {
        HStack(spacing: 12) {
            Group {
                Text(scripture.firstMetaDataValue).bold() +
                Text(" \(scripture.firstMetaDataKey)").foregroundColor(.secondary)
            }
            .font(.subheadline)
            
            
            Group {
                Text(scripture.secondMetaDataValue).bold() +
                Text(" \(scripture.secondMetaDataKey)").foregroundColor(.secondary)
            }
            .font(.subheadline)
        }
    }
    
    private func setThemes() {
        textColor = ColorTokens.setTextColor(theme: settingsViewModel.selectedChatTheme)
    }
}


struct MetadataUnit: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(value)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundStyle(.primary)
            
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
    }
}
