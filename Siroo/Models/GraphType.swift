//
//  GraphType.swift
//  Siroo
//
//  Created by jeongbae bang on 2/7/24.
//

import Foundation

enum GraphType: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case bar = "차트 표"
    case list = "차트 리스트"
}
