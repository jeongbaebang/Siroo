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
    @Published var previousActiveID: UUID?
    @Published var isActive = false
    @Published var isPause = false
    @Published var isDone = true
    @Published var secondsElapsed = 0
    @Published var taskItemList: [TaskItem] = [
        .init(systemName: .heart, label: "빈 작업#1"),
        .init(systemName: .heart, label: "빈 작업#2"),
        .init(systemName: .heart, label: "빈 작업#3"),
        .init(systemName: .heart, label: "빈 작업#4"),
        .init(systemName: .heart, label: "빈 작업#5"),
        .init(systemName: .heart, label: "빈 작업#6")
    ]
   @Published var activityRecordList: [ActivityRecord] = []
    
    private var timer: Timer?
    private var lastBackgroundTime: Date?
    
    /// 싱글톤 패턴 적용
    static let shared = TaskViewViewModel()
    
    private init() {
        setupLifecycleObserver()
        initializeActiveIDIfNeeded()
    }
    
    deinit {
        cleanupLifecycleObserver()
    }
    
    private func initializeActiveIDIfNeeded() {
        // taskItemList가 비어있지 않은 경우 첫 번째 요소의 id를 activeID로 설정
        if let firstItemID = taskItemList.first?.id {
            activeID = firstItemID
        }
    }
    
    func saveActivityRecord() {
        let currentItemIndex = indexOfActiveItem()
        let label = activityRecordList.addDuplicateLabel(targetIndex: currentItemIndex, label: activeItem.label)
        
        if var item = activityRecordList.first(where: {$0.taskItemID == activeItem.id}) {
            item.secondsElapsed += secondsElapsed
            item.label = label
            item.systemName = activeItem.systemName
            
            activityRecordList[currentItemIndex] = item
        } else {
            let newRecord = ActivityRecord(
                taskItemID: activeItem.id,
                taskItemIndex: currentItemIndex,
                secondsElapsed: secondsElapsed,
                systemName: activeItem.systemName,
                label: label)
            
            activityRecordList.append(newRecord)
        }
        
        print(activityRecordList)
        
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
        let seconds = 1
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.secondsElapsed += seconds
            }
        }
    }
    
    private func stopTimer() {
        if let timer = self.timer {
            timer.invalidate()
            
            self.timer = nil
        }
    }
    
    private var currentAcitveID: UUID? {
        return hasPreviousActiveID ? previousActiveID : activeID
    }
    
    private var hasPreviousActiveID: Bool {
        return previousActiveID != nil
    }
    
    var isCanSave: Bool {
        return secondsElapsed != 0
    }
    
    var isCanComplete: Bool {
        return isDone == true && isCanSave
    }
    
    var activeItem: TaskItem {
        let currentItemIndex = indexOfActiveItem()
        
        return taskItemList[currentItemIndex]
    }
    
    func indexOfActiveItem() -> Int {
        guard let index = taskItemList.firstIndex(where: { $0.id == currentAcitveID }) else {
            return 0
        }
        
        return index
    }
    
    func savePreviousActiveID() {
        if activeID != nil {
            previousActiveID = activeID
        }
    }
    
    func updateTaskItem<T: Equatable >(for keyPath: WritableKeyPath<TaskItem, T>, with newValue: T) {
        let currentItemIndex = indexOfActiveItem()
        let currentItem = taskItemList[currentItemIndex]
        
        // 현재 값과 새로운 값이 같은지 확인.
        if currentItem[keyPath: keyPath] != newValue {
            // 값이 다르면, 새로운 값으로 업데이트.
            taskItemList[currentItemIndex][keyPath: keyPath] = newValue
        }
    }
    
    func updateRecordItem<T: Equatable>(for keyPath: WritableKeyPath<ActivityRecord, T>, with newValue: T) {
        let currentItemIndex = indexOfActiveItem()
            
            // 변경하려는 값과 다른 값을 가진 레코드가 존재하는지 확인.
            let hasDifferentValue = activityRecordList.contains { record in
                // 배열의 다른 요소에 같은 인덱스를 가진 요소가 있고, 해당 속성의 값이 다른지 확인.
                record.taskItemIndex == currentItemIndex && record[keyPath: keyPath] != newValue
            }
            
            // 모든 해당 레코드가 새로운 값과 같다면, 순회 및 업데이트를 하지 않는다.
            guard hasDifferentValue else { return }
            
            // 변경해야 할 레코드가 있다면, 해당 레코드만 업데이트
            activityRecordList = activityRecordList.map { record in
                var modifiedRecord = record
                
                if modifiedRecord.taskItemIndex == currentItemIndex {
                    modifiedRecord[keyPath: keyPath] = newValue
                }
                
                return modifiedRecord
            }
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
    
        secondsElapsed = 0
    }
}
