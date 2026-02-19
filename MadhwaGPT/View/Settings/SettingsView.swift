//
//  SettingsView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/14/26.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            Text("Settings")
            
            Spacer()
        }
    }
}


struct ChatLevel: Identifiable {
    var id = UUID()
    let title: String
    let description: String
}

struct ChatThemes: Identifiable {
    var id = UUID()
    let title: String
    let description: String
    let color: Color
}
