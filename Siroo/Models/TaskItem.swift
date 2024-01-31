//
//  TaskItem.swift
//  Siroo
//
//  Created by jeongbae bang on 1/24/24.
//

import Foundation

struct TaskItem: Identifiable {
    let id: UUID = .init()
    var systemName: String
    var label: String
}
