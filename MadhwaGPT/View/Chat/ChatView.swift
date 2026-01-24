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
        
        NavigationStack {
            VStack(spacing: 12) {
                
                Spacer()
                    .frame(height: 20)
                
                imageView
                
                Text(Strings.chatTitle)
                    .foregroundStyle(Color.gray)
                    .font(.caption)
                
                Spacer()
                
                HStack(spacing: 8.0) {
                    ExpandingTextInput(text: $message)
                    
                    Button {
                        print("Send tapped : \(message)")
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Circle().fill(Color.orange.opacity(0.8)))
                    }
                }
                .padding()
            }
            .background(backgroundColor)
        }
    }
    
    private var imageView: some View {
        VStack {
            Image("madhwaImage")
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        }
        .frame(maxWidth: .infinity)
    }
}
