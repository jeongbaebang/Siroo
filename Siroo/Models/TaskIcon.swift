//
//  TaskIcon.swift
//  Siroo
//
//  Created by jeongbae bang on 2/2/24.
//

import Foundation

enum TaskIcon: String, CaseIterable, Identifiable {
    case heart = "heart.fill"
    case learning1 = "book.closed"
    case Learning2 = "graduationcap"
    case work1 = "briefcase"
    case work2 = "desktopcomputer"
    case hobby1 = "paintpalette"
    case hobby2 = "guitars"
    case exercise1 = "figure.walk"
    case exercise2 = "sportscourt"
    
    var id: String { rawValue }
}
