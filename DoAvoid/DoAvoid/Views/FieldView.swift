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
                    return item.kind == .do
                case .avoidsOnly:
                    return item.kind == .avoid
                }
            }
            
            let rowHeight = geo.size.height / CGFloat(visibleItems.count)
            
            VStack(spacing: 0) {
                ForEach(visibleItems.indices, id: \.self) { index in
                    let item = visibleItems[index]
                    
                    BarView(
                        title: item.title,
                        color: item.kind == .do
                        ? Color.yellow.opacity(0.45)
                        : Color.gray.opacity(0.25),
                        isTop: index == 0,
                        isBottom: index == visibleItems.count - 1,
                        daysCount: item.markedDays.count,
                        isMarkedToday: item.markedDays.contains(Date().startOfDay),
                        showBadges: displayMode == .withBadges
                    )
                    .frame(height: rowHeight)
                }
            }
        }
    }
}
