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
            
            HStack(spacing: 8.0) {
                ExpandingTextInput(text: $message)
                   
                Image(systemName: "paperplane")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Circle().fill(Color.orange.opacity(0.5)))
            }
            .padding()
            
            Spacer()
                .frame(height: 20)
        }
        .background(backgroundColor)
    }
}

