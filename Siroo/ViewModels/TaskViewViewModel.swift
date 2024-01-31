//
//  TaskViewViewModel.swift
//  Siroo
//
//  Created by jeongbae bang on 1/18/24.
//

import Foundation
import UIKit

class TaskViewViewModel: ObservableObject {
    @Published var activeID: UUID?
    @Published var isActive = false
    @Published var isPause = false
    @Published var isDone = true
    @Published var secondsElapsed = 0
    @Published var taskItemList: [TaskItem] = [
        .init(systemName: "heart.fill", label: "작업#1"),
        .init(systemName: "heart.fill", label: "작업#2"),
        .init(systemName: "heart.fill", label: "작업#3"),
        .init(systemName: "heart.fill", label: "작업#4"),
        .init(systemName: "heart.fill", label: "작업#5"),
        .init(systemName: "heart.fill", label: "작업#6")
    ]
    
    private var timer: Timer?
    private var lastBackgroundTime: Date?
    
    init() {
        setupLifecycleObserver()
    }
    
    deinit {
        cleanupLifecycleObserver()
    }
    
    private func setupLifecycleObserver() {
        let center = NotificationCenter.default
        
        center.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self] _ in
            self?.pauseTimerIfNeeded()
        }
        
        center.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] _ in
            self?.resumeTimerIfNeeded()
        }
    }
    
    private func cleanupLifecycleObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func pauseTimerIfNeeded() {
        if isActive {
            lastBackgroundTime = Date()
            
            stopTimer()
        }
    }
    
    private func resumeTimerIfNeeded() {
        if !isActive { return }
        
        if let lastBackgroundTime = lastBackgroundTime {
            let timeInBackground = Date().timeIntervalSince(lastBackgroundTime)
            secondsElapsed += Int(timeInBackground)
        }
        
        startTimer()
    }

    
    private func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.secondsElapsed += 1
            }
        }
    }
    
    private func stopTimer() {
        if let timer = self.timer {
            timer.invalidate()
            
            self.timer = nil
        }
    }
    
    public var isCanSave: Bool {
        return secondsElapsed != 0
    }
    
    public var isCanComplete: Bool {
        return isDone == true && isCanSave
    }
    
    func activeStopWatch() {
        isActive = true
        isPause = false
        isDone = false
        
        startTimer()
    }
    
    func deactivateStopWatch() {
        isActive = false
        isPause = true
        
        stopTimer()
    }
    
    func completeTask() {
        isActive = false
        isPause = false
        isDone = true
        activeID = nil
        
        stopTimer()
    }
    
    func initTask() {
        isActive = false
        isPause = false
        isDone = true
        activeID = nil
    
        secondsElapsed = 0
    }
}
