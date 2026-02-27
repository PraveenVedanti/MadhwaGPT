//
//  ProgressBar.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/24/26.
//

import Foundation
import SwiftUI

struct CircularProgressRing: View {
    
    var progress: Double
    var lineWidth: CGFloat = 2
    var size: CGFloat = 32
    
    var body: some View {
        ZStack {
            
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.85, green: 0.65, blue: 0.35),
                            Color(red: 1.0, green: 0.85, blue: 0.55)
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.6), value: progress)
            
            // Percentage Text
            Text("\(Int(progress * 100))%")
                .font(.system(size: size * 0.28, weight: .semibold))
                .foregroundColor(.primary)
        }
        .frame(width: size, height: size)
    }
}
