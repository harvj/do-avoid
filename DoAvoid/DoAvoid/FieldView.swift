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
    
    var body: some View {
        GeometryReader { geo in
            let rowHeight = geo.size.height / CGFloat(store.items.count)
            
            VStack(spacing: 0) {
                ForEach(store.items.indices, id: \.self) { index in
                    let item = store.items[index]
                    
                    BarView(
                        title: item.title,
                        color: item.kind == .do
                        ? Color.yellow.opacity(0.45)
                        : Color.gray.opacity(0.25),
                        isTop: index == 0,
                        isBottom: index == store.items.count - 1,
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
