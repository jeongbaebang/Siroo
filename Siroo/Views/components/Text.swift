//
//  StopwatchView.swift
//  Siroo
//
//  Created by jeongbae bang on 1/18/24.
//

import SwiftUI

struct LargeTitle: View {
    var value: String
    
    init(_ value: String) {
        self.value = value
    }
    
    var body: some View {
        Text(value)
            .font(.largeTitle)
            .fontWeight(.bold)
    }
}

struct Stopwatch: View {
    var secondsElapsed: Int
    
    var body: some View {
        LargeTitle(formatTime(seconds: secondsElapsed))
    }
}

#Preview {
    Stopwatch(secondsElapsed: 4600)
}
