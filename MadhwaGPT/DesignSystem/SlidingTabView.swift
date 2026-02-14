//
//  SlidingTabView.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 2/10/26.
//

import Foundation
import SwiftUI

/// A customizable view that displays a horizontal bar of tabs with a sliding underline animation
/// and a paging content area.
///
/// Use `SlidingTabView` when you want a segment-style navigation that allows both tapping
/// and swiping between views.
///
/// ### Example Usage:
/// ```swift
/// SlidingTabView(
///     tabs: MyEnum.allCases,
///     selectedTab: $currentTab,
///     activeColor: .blue,
///     titleMapper: { $0.rawValue }
/// ) { tab in
///     Text("Content for \(tab.rawValue)")
/// }
/// ```
struct SlidingTabView<T: Hashable, Content: View>: View {
    
    // The collection of data models representing each tab.
    let tabs: [T]
    
    // A binding to the currently selected tab.
    @Binding var selectedTab: T
    
    // The color used for the sliding underline and the active text.
    let activeColor: Color
    
    // A closure that transforms a tab item into a displayable String.
    let titleMapper: (T) -> String
    
    // A ViewBuilder closure that provides the view hierarchy for a given tab.
    @ViewBuilder let content: (T) -> Content
    
    // Namespace used to coordinate the "underline" animation across different buttons.
    @Namespace private var animation

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Tab Bar
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { tab in
                    tabButton(for: tab)
                }
            }
            .padding(.top, 12)
            
            Divider()
            
            // MARK: - Paging Content
            TabView(selection: $selectedTab) {
                ForEach(tabs, id: \.self) { tab in
                    content(tab)
                        .tag(tab)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
    
    // Helper view to construct individual tab buttons.
    @ViewBuilder
    private func tabButton(for tab: T) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 12) {
                Text(titleMapper(tab))
                    .fontWeight(.medium)
                    .foregroundColor(selectedTab == tab ? .primary : .gray)
                
                ZStack {
                    if selectedTab == tab {
                        Rectangle()
                            .fill(activeColor)
                            .frame(height: 2)
                        // This effect identifies this specific rectangle as the
                        // source/destination for the slide animation.
                            .matchedGeometryEffect(id: "underline", in: animation)
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 2)
                    }
                }
                .padding(.horizontal, 8)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
