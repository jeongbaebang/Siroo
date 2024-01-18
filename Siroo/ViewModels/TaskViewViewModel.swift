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
    
    func activeStopWatch() {
        self.isActive = true
        self.isPause = true
        self.isDone = false
    }
    
    func deactivateStopWatch() {
        self.isActive = false
    }
    
    func completeTask() {
        self.isActive = false
        self.isPause = false
        self.isDone = true
    }
}
