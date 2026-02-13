//
//  AvoidState.swift
//  DoAvoid
//
//  Created by Jim Harvey on 2/4/26.
//

import Foundation

enum AvoidState: String, Codable {
    case solid        // fresh / active avoidance (concrete intact)
    case cracked      // healing, but still relevant
    case open         // habit has weakened significantly
    case overgrown    // resolved; ready for retirement
}
