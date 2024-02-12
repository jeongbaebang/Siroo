//
//  WorkView.swift
//  Siroo
//
//  Created by jeongbae bang on 1/14/24.
//

import SwiftUI

struct TaskView: View {
    @ObservedObject var viewModel = TaskViewViewModel.shared
    @State private var isShowingSheet = false
    
    let paddingTop: CGFloat = 100
    let paddingBottom: CGFloat = 70
    
    var body: some View {
        VStack {
            if viewModel.isCanComplete {
                CompleteTask()
            } else {
                StopwatchView()
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            let maxWidth: CGFloat = 390
            let isLargeWidth = UIScreen.main.bounds.width > maxWidth
            
            TaskModalView(viewModel: viewModel)
                .presentationDetents([isLargeWidth ? .medium : .large])
        }
        .padding(.top, paddingTop)
        .padding(.bottom, paddingBottom)
        .animation(.interactiveSpring, value: viewModel.isCanComplete)
        .onAppear {
            viewModel.resetDataIfNeeded()
        }
    }
    
    @ViewBuilder
    func StopwatchView() -> some View {
        let itemSpacing: CGFloat = 20
        let startButton = ("작업 시작", "arrowtriangle.right.fill")
        let pauseButton = ("작업 일시정지", "stop.fill")
        let stopButton = ("작업 종료", "stopwatch.fill")
        
        Stopwatch(secondsElapsed: viewModel.secondsElapsed)
        
        Spacer()
        
        VStack(spacing: itemSpacing) {
            if !viewModel.isActive {
                CustomButton(title: startButton.0, systemImage: startButton.1, color: .green, isDisabled: viewModel.isActive) {
                    viewModel.activeStopWatch()
                }
            } else {
                CustomButton(title: pauseButton.0, systemImage: pauseButton.1, color: .red, isDisabled: false) {
                    viewModel.deactivateStopWatch()
                }
            }
            
            CustomButton(title: stopButton.0, systemImage: stopButton.1, color: .blue, isDisabled: !viewModel.isCanSave) {
                viewModel.completeTask()
            }
            .animation(.default, value: viewModel.isCanSave)
        }
    }
    
    @ViewBuilder
    func CompleteTask() -> some View {
        let items = viewModel.taskItemList
        let title = "어떤 작업을 완료했나요?"
        let editButtonText = "편집"
        let offsetY: CGFloat = -120
        let buttonSpacing: CGFloat = 20
        let completeButton = ("완료", "clock.badge.checkmark.fill")
        let carouselItemWidth: CGFloat = 200
        
        LargeTitle(title)
        
        ZStack {
            Carousel(list: items, itemWidth: carouselItemWidth, activeID: $viewModel.activeID, previousActiveID: $viewModel.previousActiveID) { item, isFocused in
                TaskItemView(
                    systemName: item.systemName,
                    label: item.label,
                    isFocused: isFocused
                )
            }
            
            HStack {
                Spacer()
                
                Button(editButtonText) {
                    isShowingSheet.toggle()
                }
            }
            .padding()
            .offset(y: offsetY)
        }
        
        VStack(spacing: buttonSpacing) {
            CustomButton(title: completeButton.0, systemImage: completeButton.1, color: .green, isDisabled: false) {
                viewModel.savePreviousActiveID()
                viewModel.resetDataIfNeeded()
                viewModel.saveActivityRecord()
                viewModel.saveTaskItemsToUserDefaults()
                viewModel.saveActivityRecordsToUserDefaults()
                viewModel.initTask()
            }
        }
    }
}

#Preview {
  TaskView()
}
