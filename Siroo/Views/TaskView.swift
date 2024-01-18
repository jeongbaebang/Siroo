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
            Stopwatch(secondsElapsed: viewModel.secondsElapsed)

            Spacer()
            
            VStack(spacing: 20) {
                if !viewModel.isActive {
                    CustomButton(title: "작업 시작", systemImage: "arrowtriangle.right.fill", color: .green, isDisabled: viewModel.isActive) {
                        viewModel.activeStopWatch()
                    }
                } else {
                    CustomButton(title: "작업 일시정지", systemImage: "stop.fill", color: .red, isDisabled: !viewModel.isPause) {
                        viewModel.deactivateStopWatch()
                    }
                }
                
                CustomButton(title: "작업 종료", systemImage: "stopwatch.fill", color: .blue, isDisabled: viewModel.isDone) {
                    viewModel.completeTask()
                }
            }
        }
        .padding(.top, 100)
        .padding(.bottom, 70)
    }
}

#Preview {
    TaskView()
}



