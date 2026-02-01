//
//  DoAvoidItem.swift
//  DoAvoid
//
//  Created by Jim Harvey on 1/31/26.
//

import Foundation

enum DoAvoidKind {
    case `do`
    case avoid
}

struct DoAvoidItem: Identifiable {
    let id = UUID()
    let title: String
    let kind: DoAvoidKind

    /// Set of days this item was explicitly marked
    /// - For .do → days it WAS done
    /// - For .avoid → days it WAS avoided
    var markedDays: Set<Date> = []
}
