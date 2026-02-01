//
//  BarView.swift
//  DoAvoid
//
//  Created by Jim Harvey on 1/31/26.
//

import Foundation
import SwiftUI

struct BarView: View {
    let title: String
    let color: Color
    let isTop: Bool
    let isBottom: Bool
    let daysCount: Int
    let isMarkedToday: Bool
    let showBadges: Bool

    var body: some View {
        ZStack {
            // Background layer
            color
                .ignoresSafeArea(
                    edges: isTop ? .top : (isBottom ? .bottom : [])
                )
            
            // Top border line
            VStack(spacing: 0) {
                if !isTop {
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 1)
                }
                Spacer()
            }

            // Content layer
            Text(title)
                .font(.system(.title, design: .rounded))
                .fontWeight(.semibold)
                .textCase(.uppercase)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.6)
                .padding(.horizontal, 12)
            
        }
    }

    private var safeTopPadding: CGFloat {
        UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .safeAreaInsets.top ?? 0
    }

    private var safeBottomPadding: CGFloat {
        UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .safeAreaInsets.bottom ?? 0
    }
}
