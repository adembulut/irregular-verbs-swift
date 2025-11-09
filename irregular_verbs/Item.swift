//
//  Item.swift
//  irregular_verbs
//
//  Created by adem bulut on 9.11.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
