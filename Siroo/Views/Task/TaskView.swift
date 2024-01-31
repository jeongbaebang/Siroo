//
//  WorkView.swift
//  Siroo
//
//  Created by jeongbae bang on 1/14/24.
//

import SwiftUI

struct TaskView: View {
    @StateObject var viewModel = TaskViewViewModel()

    var body: some View {
        VStack {
            if viewModel.isCanComplete {
                CompleteTask()
            } else {
                StopwatchView()
            }
        }
        .padding(.top, 100)
        .padding(.bottom, 70)
        .animation(.interactiveSpring, value: viewModel.isCanComplete)
    }
    
    @ViewBuilder
    func StopwatchView() -> some View {
        Stopwatch(secondsElapsed: viewModel.secondsElapsed)
        
        Spacer()
        
        VStack(spacing: 20) {
            if !viewModel.isActive {
                CustomButton(title: "작업 시작", systemImage: "arrowtriangle.right.fill", color: .green, isDisabled: viewModel.isActive) {
                    viewModel.activeStopWatch()
                }
            } else {
                CustomButton(title: "작업 일시정지", systemImage: "stop.fill", color: .red, isDisabled: false) {
                    viewModel.deactivateStopWatch()
                }
            }
            
            CustomButton(title: "작업 종료", systemImage: "stopwatch.fill", color: .blue, isDisabled: !viewModel.isCanSave) {
                viewModel.completeTask()
            }
            .animation(.default, value: viewModel.isCanSave)
            
        }
    }
    
    @ViewBuilder
    func CompleteTask() -> some View {
        let items = viewModel.taskItemList
        
        Text("어떤 작업을 완료했나요?")
            .font(.largeTitle)
            .fontWeight(.bold)
        
        Carousel(list: items, itemWidth: 200, activeID: $viewModel.activeID) { item, isFocused in
            TaskItemView(
                systemName: item.systemName,
                label: item.label,
                isFocused: isFocused
            )
        }
        
        VStack(spacing: 20) {
            CustomButton(title: "완료", systemImage: "clock.badge.checkmark.fill", color: .green, isDisabled: false) {
                if let id = viewModel.activeID, let activeItem = items.first(where: { $0.id == id }) {
                    print("선택된 아이템: \(activeItem)")
                } else if let firstItem = items.first {
                    print("선택된 아이템: \(firstItem)")
                } else {
                    print("아이템이 없습니다.")
                }
                
                viewModel.initTask()
            }
        }
    }
}

#Preview {
    TaskView()
}
