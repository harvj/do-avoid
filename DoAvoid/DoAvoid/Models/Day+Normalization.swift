//
//  Day+Normalization.swift
//  DoAvoid
//
//  Created by Jim Harvey on 1/31/26.
//

import Foundation

extension DayEntry {
    static func normalize(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }
}

extension Date {
    var normalizedDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
