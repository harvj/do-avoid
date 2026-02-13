//
//  FieldView.swift
//  DoAvoid
//
//  Created by Jim Harvey on 1/31/26.
//

import Foundation
import SwiftUI

struct FieldView: View {
    @ObservedObject var store: DoAvoidStore
    let displayMode: DisplayMode
    let filterMode: FilterMode
    
    var body: some View {
        GeometryReader { geo in
            let visibleItems: [DoAvoidItem] = store.items.filter { item in
                switch filterMode {
                case .all:
                    return true
                case .dosOnly:
                    return item.kind == .doItem
                case .avoidsOnly:
                    return item.kind == .avoidItem
                }
            }
            
            let rowHeight = geo.size.height / CGFloat(visibleItems.count)
            
            VStack(spacing: 0) {
                ForEach(visibleItems.indices, id: \.self) { index in
                    let item = visibleItems[index]
                    
                    BarView(
                        title: item.title,
                        color: item.kind == .doItem
                        ? Color.yellow.opacity(0.45)
                        : Color.gray.opacity(0.25),
                        isTop: index == 0,
                        isBottom: index == visibleItems.count - 1,
                        daysCount: item.entries.values.filter { $0.isMarked }.count,
                        isMarkedToday: (item.entry(for: Date())?.isMarked ?? false),
                        showBadges: displayMode == .withBadges
                    )
                    .frame(height: rowHeight)
                }
            }
        }
    }
}
