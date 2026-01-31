//
//  ContentView.swift
//  DoAvoid
//
//  Created by Jim Harvey on 1/30/26.
//

import SwiftUI

struct DoAvoidItem: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
}

struct BarView: View {
    let title: String
    let color: Color
    let isTop: Bool
    let isBottom: Bool

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
//                .padding(.top, isTop ? safeTopPadding : 0)
//                .padding(.bottom, isBottom ? safeBottomPadding : 0)
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

struct ContentView: View {
    let items = [
        ("Stretching", Color.yellow.opacity(0.45)),
        ("Veggies", Color.yellow.opacity(0.45)),
        ("Juice", Color.yellow.opacity(0.45)),
        ("Soda", Color.gray.opacity(0.25)),
        ("Fast Food", Color.gray.opacity(0.25)),
        ("Late Night Snacking", Color.gray.opacity(0.25))
    ]

    var body: some View {
        GeometryReader { geo in
            let rowHeight = geo.size.height / CGFloat(items.count)

            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    BarView(
                        title: items[index].0,
                        color: items[index].1,
                        isTop: index == 0,
                        isBottom: index == items.count - 1
                    )
                    .frame(height: rowHeight)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
