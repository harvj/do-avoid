//
//  DayEntry.swift
//  DoAvoid
//
//  Created by Jim Harvey on 2/3/26.
//

import Foundation

/// Represents one calendar day for a single item
struct DayEntry: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date

    /// Whether the item was marked on this day
    var isMarked: Bool

    /// Optional freeform note (very minimal journaling)
    var note: String?

    /// Optional numeric value (meaning defined by user)
    /// e.g. glasses of water, minutes, reps, etc.
    var count: Int?

    init(
        date: Date,
        isMarked: Bool = false,
        note: String? = nil,
        count: Int? = nil
    ) {
        self.id = UUID()
        self.date = DayEntry.normalize(date)
        self.isMarked = isMarked
        self.note = note
        self.count = count
    }
}

