//
//  StopwatchView.swift
//  Siroo
//
//  Created by jeongbae bang on 1/18/24.
//

import SwiftUI

struct Stopwatch: View { 
    var secondsElapsed: Int
    
    var body: some View {
        Text(formatTime(seconds: secondsElapsed))
            .font(.largeTitle)
            .fontWeight(.bold)
    }
}

#Preview {
    Stopwatch(secondsElapsed: 4600)
}
