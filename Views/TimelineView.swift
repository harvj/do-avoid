//
//  TimelineView.swift
//  DoAvoid
//
//  Created by Jim Harvey on 1/31/26.
//

import Foundation
import SwiftUI

struct TimelineView: View {
    let store: DoAvoidStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(store.items) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.title.uppercased())
                            .font(.headline)

                        let markedDates = item.entries.values
                            .filter { $0.isMarked }
                            .map { $0.date }
                        
                        if markedDates.isEmpty {
                            Text("No history yet")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(
                                markedDates.sorted(by: >),
                                id: \.self
                            ) { day in
                                Text(day.formatted(date: .abbreviated, time: .omitted))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

