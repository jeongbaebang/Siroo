//
//  TaskItem.swift
//  Siroo
//
//  Created by jeongbae bang on 1/24/24.
//

import Foundation

struct TaskItem: Identifiable, Encodable, Decodable {
    var id: UUID = .init()
    var systemName: TaskIcon
    var label: String
}
