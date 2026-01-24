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
    
    var body: some View {
        NavigationStack {
            
        }
        .background(backgroundColor)
        .navigationTitle(scripture.title)
    }
}
