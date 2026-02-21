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
    
    var body: some View {
        HStack(spacing: 16) {
            
            checkMarkView
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(scripture.title)
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                    languageView
                }
                
                Text(scripture.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 16) {
                    MetadataUnit(label: scripture.firstMetaDataValue, value: scripture.firstMetaDataKey)
                    MetadataUnit(label: scripture.secondMetaDataKey, value: scripture.secondMetaDataValue)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.black.opacity(0.0001))
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill( isSelected ? .orange.opacity(0.3) : Color(.secondarySystemBackground))
        )
        .shadow(
            color: .black.opacity(isSelected ? 0.08 : 0.03),
            radius: 10,
            y: 4
        )
    }
    
    private var checkMarkView: some View {
        ZStack {
            Circle()
                .stroke(isSelected ? Color.orange : Color.secondary.opacity(0.3), lineWidth: 1)
                .frame(width: 16, height: 16)
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.orange)
            }
        }
    }
    
    private var languageView: some View {
        Text(scripture.language)
            .font(.system(size: 10, weight: .black))
            .textCase(.uppercase)
            .foregroundStyle(.orange)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.orange.opacity(0.12))
            )
            .overlay(
                Capsule()
                    .stroke(Color.orange.opacity(0.25), lineWidth: 1)
            )
    }
    
    private var metadataView: some View {
        HStack(spacing: 12) {
            Group {
                Text(scripture.firstMetaDataValue).bold() +
                Text(" \(scripture.firstMetaDataKey)").foregroundColor(.secondary)
            }
            .font(.subheadline)
            
            Divider()
                .frame(height: 14)
            
            Group {
                Text(scripture.secondMetaDataValue).bold() +
                Text(" \(scripture.secondMetaDataKey)").foregroundColor(.secondary)
            }
            .font(.subheadline)
        }
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
