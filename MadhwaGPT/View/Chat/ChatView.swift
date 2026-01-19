//
//  ChatView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/17/26.
//

import Foundation
import SwiftUI

struct ChatView: View {
    
    @State private var message = ""
    let backgroundColor = Color(red: 1.0, green: 0.976, blue: 0.961)
    
    var body: some View {
        VStack {
            Spacer()
            
            ExpandingTextInput(text: $message)
                .padding()
        }
        .background(backgroundColor)
    }
}

