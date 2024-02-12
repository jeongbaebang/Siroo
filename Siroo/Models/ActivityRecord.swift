//
//  activityRecord.swift
//  Siroo
//
//  Created by jeongbae bang on 2/5/24.
//

import Foundation

struct ActivityRecord: Identifiable {
    let id: UUID = .init()
    var addedTime: Date
    var taskItemID: UUID
    var taskItemIndex: Int
    var secondsElapsed: Int
    var systemName: TaskIcon
    var label: String
    
    init(taskItemID: UUID, taskItemIndex: Int, secondsElapsed: Int, systemName: TaskIcon, label: String) {
        self.taskItemID = taskItemID
        self.taskItemIndex = taskItemIndex
        self.secondsElapsed = secondsElapsed
        self.systemName = systemName
        self.label = label
        self.addedTime = Date() // 인스턴스가 생성될 때 현재 시간으로 자동 설정
    }
}

extension [ActivityRecord] {
    func findRecord(_ on: String) -> ActivityRecord? {
        
        if let record = self.first(where: {
            $0.label == on
        }) {
            return record
        }
        
        return nil
    }
    
    func isDuplicate(targetIndex: Int, label: String) -> Bool {
        return self.first { $0.taskItemIndex != targetIndex && $0.label == label } != nil
    }
    
    func addDuplicateLabel(targetIndex: Int, label: String) -> String {
        let increment = 1
        
        if self.isDuplicate(targetIndex: targetIndex, label: label) {
            return "\(label) [\(targetIndex + increment)]"
        }
        
        return label
    }
}
