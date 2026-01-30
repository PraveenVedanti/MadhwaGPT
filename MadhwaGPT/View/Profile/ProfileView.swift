//
//  ProfileView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/29/26.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    let backgroundColor = Color(red: 1.0, green: 0.976, blue: 0.961)
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 20)
           
            Text("Profile")
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
    }
}
