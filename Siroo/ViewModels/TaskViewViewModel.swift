//
//  TaskViewViewModel.swift
//  Siroo
//
//  Created by jeongbae bang on 1/18/24.
//

import Foundation
import UIKit

class TaskViewViewModel: ObservableObject {
    @Published var isActive = false
    @Published var isPause = false
    @Published var isDone = true
    @Published var secondsElapsed = 0
    
    private var timer: Timer?
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.secondsElapsed += 1
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        timer = nil
    }
    
    func activeStopWatch() {
        startTimer()
        
        self.isActive = true
        self.isPause = true
        self.isDone = false
    }
    
    func deactivateStopWatch() {
        stopTimer()
        
        self.isActive = false
    }
    
    func completeTask() {
        stopTimer()
        
        self.isActive = false
        self.isPause = false
        self.isDone = true
    }
}
