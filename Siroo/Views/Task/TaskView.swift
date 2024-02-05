//
//  WorkView.swift
//  Siroo
//
//  Created by jeongbae bang on 1/14/24.
//

import SwiftUI

struct TaskView: View {
    @StateObject var viewModel = TaskViewViewModel()
    @State private var isShowingSheet = false
    
    var body: some View {
        VStack {
            if viewModel.isCanComplete {
                CompleteTask()
            } else {
                StopwatchView()
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            let maxWidth: CGFloat = 400
            let isLargeWidth = UIScreen.main.bounds.width > maxWidth
            
            TaskModalView(viewModel: viewModel)
                .presentationDetents([isLargeWidth ? .medium : .large])
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
        
        LargeTitle("어떤 작업을 완료했나요?")
        
        ZStack {
            Carousel(list: items, itemWidth: 200, activeID: $viewModel.activeID, lastActiveID: $viewModel.previousActiveID) { item, isFocused in
                TaskItemView(
                    systemName: item.systemName,
                    label: item.label,
                    isFocused: isFocused
                )
            }
            
            HStack {
                Spacer()
                
                Button("편집") {
                    isShowingSheet.toggle()
                }
            }
            .padding()
            .offset(y: -120)
        }
        
        VStack(spacing: 20) {
            CustomButton(title: "완료", systemImage: "clock.badge.checkmark.fill", color: .green, isDisabled: false) {
                viewModel.saveLastActiveID()
                viewModel.initTask()
                
                /// TODO: 로그 삭제
                print("선택된 아이템: \(viewModel.activeItem)")
            }
        }
    }
}

#Preview {
    TaskView()
}
