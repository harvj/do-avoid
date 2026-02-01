//
//  DoAvoidStore.swift
//  DoAvoid
//
//  Created by Jim Harvey on 1/31/26.
//

import Foundation
import SwiftUI

final class DoAvoidStore: ObservableObject {
    @Published var items: [DoAvoidItem] = [
        DoAvoidItem(title: "Stretching", kind: .do),
        DoAvoidItem(title: "Veggies", kind: .do),
        DoAvoidItem(title: "Soda", kind: .avoid),
        DoAvoidItem(title: "Fast Food", kind: .avoid),
        DoAvoidItem(title: "Late Night Snacking", kind: .avoid)
    ]
    
    func toggleToday(for itemID: UUID) {
        guard let index = items.firstIndex(where: { $0.id == itemID }) else {
            return
        }

        let today = Date().startOfDay

        if items[index].markedDays.contains(today) {
            items[index].markedDays.remove(today)
        } else {
            items[index].markedDays.insert(today)
        }
    }
}
