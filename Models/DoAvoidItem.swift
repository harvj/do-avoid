//
//  DoAvoidItem.swift
//  DoAvoid
//
//  Created by Jim Harvey on 1/31/26.
//

import Foundation

struct DoAvoidItem: Identifiable, Codable {
    let id: UUID
    var title: String
    let kind: DoAvoidKind
    let createdAt: Date

    /// All tracked days, keyed by normalized date
    private(set) var entries: [Date: DayEntry]

    /// Whether this item is no longer active (used mainly for Avoids)
    private(set) var isRetired: Bool

    init(
        title: String,
        kind: DoAvoidKind,
        createdAt: Date = Date()
    ) {
        self.id = UUID()
        self.title = title
        self.kind = kind
        self.createdAt = createdAt
        self.entries = [:]
        self.isRetired = false
    }
}

extension DoAvoidItem {
    static let doCycleLength = 40
    
    /// Total number of positive actions taken
    var progressUnits: Int {
        guard kind == .doItem else { return 0 }
        return entries.values.filter { $0.isMarked }.count
    }

    /// How many full cycles have been completed
    var completedCycles: Int {
        progressUnits / Self.doCycleLength
    }

    /// Position within the current cycle (0..<40)
    var targetPhase: Int {
        progressUnits % Self.doCycleLength
    }
    
    /// Total days marked
    var markedDays: Int {
        entries.values.filter { $0.isMarked }.count
    }
    
    var allEntriesSorted: [DayEntry] {
        entries.values.sorted { $0.date < $1.date }
    }
    
    /// Days since creation where no entry exists
    func missedDays(until date: Date = Date()) -> Int {
        let start = createdAt.normalizedDay
        let end = date.normalizedDay

        guard let days = Calendar.current.dateComponents([.day], from: start, to: end).day else {
            return 0
        }

        let totalPossible = days + 1
        return max(0, totalPossible - entries.count)
    }
    
    func entry(for date: Date) -> DayEntry? {
        entries[date.normalizedDay]
    }

    mutating func toggleMarked(on date: Date) {
        let day = date.normalizedDay

        if var existing = entries[day] {
            existing.isMarked.toggle()
            entries[day] = existing
        } else {
            entries[day] = DayEntry(date: day, isMarked: true)
        }
    }
    
    mutating func addEntry(_ entry: DayEntry) {
        entries[entry.date] = entry
    }

    mutating func updateEntry(
        on date: Date,
        isMarked: Bool,
        note: String?,
        count: Int?
    ) {
        let day = date.normalizedDay
        entries[day] = DayEntry(
            date: day,
            isMarked: isMarked,
            note: note,
            count: count
        )
    }
    
    mutating func checkForRetirement(asOf date: Date = Date()) {
        guard kind == .avoidItem else { return }

        if avoidState(asOf: date) == .overgrown {
            isRetired = true
        }
    }
    
    /// Last day a violation occurred
    var lastViolationDate: Date? {
        guard kind == .avoidItem else { return nil }

        return entries.values
            .filter { $0.isMarked }
            .map { $0.date }
            .max()
    }

    /// Days since last violation (or since creation if none)
    func daysSinceLastViolation(asOf date: Date = Date()) -> Int {
        guard kind == .avoidItem else { return 0 }

        let reference = lastViolationDate ?? createdAt
        let start = reference.normalizedDay
        let end = date.normalizedDay

        return Calendar.current
            .dateComponents([.day], from: start, to: end)
            .day ?? 0
    }

    /// Healing-based avoid state
    func avoidState(asOf date: Date = Date()) -> AvoidState {
        let days = daysSinceLastViolation(asOf: date)

        switch days {
        case 0..<7:
            return .solid
        case 7..<21:
            return .cracked
        case 21..<40:
            return .open
        default:
            return .overgrown
        }
    }
}
