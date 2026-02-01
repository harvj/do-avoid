//
//  Day+Normalization.swift
//  DoAvoid
//
//  Created by Jim Harvey on 1/31/26.
//

import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
