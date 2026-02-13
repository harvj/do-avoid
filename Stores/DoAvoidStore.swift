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
        DoAvoidItem(title: "Stretching", kind: .doItem),
        DoAvoidItem(title: "Veggies", kind: .doItem),
        DoAvoidItem(title: "Soda", kind: .avoidItem),
        DoAvoidItem(title: "Fast Food", kind: .avoidItem),
        DoAvoidItem(title: "Late Night Snacking", kind: .avoidItem)
    ]
    
    func toggleToday(for itemID: UUID) {
        guard let index = items.firstIndex(where: { $0.id == itemID }) else {
            return
        }
        items[index].toggleMarked(on: Date())
    }
}
