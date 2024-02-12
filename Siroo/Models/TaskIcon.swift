//
//  TaskIcon.swift
//  Siroo
//
//  Created by jeongbae bang on 2/2/24.
//

import Foundation

enum TaskIcon: String, CaseIterable, Identifiable, Encodable, Decodable {
    case heart = "heart.fill"
    case learning = "book.closed"
    case rest = "cup.and.saucer.fill"
    case work1 = "briefcase"
    case work2 = "desktopcomputer"
    case hobby1 = "paintpalette"
    case hobby2 = "guitars"
    case exercise = "figure.walk"
    case sleep = "bed.double.fill"
    
    var id: String { rawValue }
}
