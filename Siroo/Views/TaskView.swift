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
        LargeTitle("어떤 작업을 완료했나요?")
        
        Spacer()
        
        VStack(spacing: 20) {
            CustomButton(title: "완료", systemImage: "clock.badge.checkmark.fill", color: .green, isDisabled: false) {
                viewModel.initTask()
            }
        }
    }
}

#Preview {
    TaskView()
}



