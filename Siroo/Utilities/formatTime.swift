//
//  formatTime.swift
//  Siroo
//
//  Created by jeongbae bang on 1/18/24.
//

import Foundation

func formatTime(seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let seconds = seconds % 60
    
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}
