//
//  TaskModalView.swift
//  Siroo
//
//  Created by jeongbae bang on 2/1/24.
//

import SwiftUI

struct TaskModalView: View {
    @ObservedObject var viewModel: TaskViewViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var currentLabel: String
    @State private var currentIcon: TaskIcon
    
    init(viewModel: TaskViewViewModel) {
        self.viewModel = viewModel
        // viewModel의 activeItem.systemName을 기반으로 currentIcon 초기값 설정
        self._currentIcon = State(initialValue: viewModel.activeItem.systemName)
        // label도 viewModel의 activeItem.label을 기반으로 초기화
        self._currentLabel = State(initialValue: viewModel.activeItem.label)
    }

    
    var body: some View {
        VStack {
            ModalTop()
            FocusIcon()
            LabelTextField()
            IconPicker()
            Spacer()
        }
    }
    
    @ViewBuilder
    func ModalTop() -> some View {
        let buttonText = "편집"
        
        Grabbar()
        
        HStack {
            Text(buttonText)
                .font(.title3)
                .fontWeight(.bold)
                
            Spacer()
            
            Button(action: { 
                dismiss()
            }, label: {
                CancelButton()
            })
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func FocusIcon() -> some View {
        let circleSize = 142.5
        let iconSize: CGFloat = 60
        
        ZStack {
            Circle()
                .fill(.regularMaterial)
                .frame(width: circleSize, height: circleSize)
            Image(systemName: currentIcon.rawValue)
                .font(.system(size: iconSize))
        }
        .padding()
    }
    
    @ViewBuilder
    func LabelTextField() -> some View {
        let labelText = "Label"
        let fieldPlaceholder = "아이콘 설명을 입력해주세요."
        let fieldPadding: CGFloat = 20
        let buttonSystemName = "multiply.circle.fill"
        let inputContainerRadius: CGFloat = 10
        
        VStack {
            HStack {
                Text(labelText)
                
                Spacer()
                
                TextField(fieldPlaceholder, text: $currentLabel)
                    .multilineTextAlignment(.center)
                    .padding(.trailing, fieldPadding)
                
                Button(action: {
                    currentLabel = ""
                }, label: {
                    Image(systemName: buttonSystemName)
                        .foregroundColor(.secondary)
                })
            }
            .padding()
            .background(.regularMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: inputContainerRadius))
        .padding()
    }
    
    @ViewBuilder
    func IconPicker() -> some View {
        Picker("IconPicker", selection: $currentIcon) {
            ForEach(TaskIcon.allCases) { icon in
                Image(systemName: icon.rawValue).tag(icon)
            }
        }
        .pickerStyle(.palette)
        .padding()
        .onChange(of: currentIcon) { _, newValue in
            viewModel.updateTaskItem(for: \.systemName, with: newValue)
        }
        .onDisappear(perform: {
            viewModel.updateTaskItem(for: \.label, with: currentLabel)
            viewModel.updateRecordItem(for: \.label, with: currentLabel)
        })
    }
}

#Preview {
    @ObservedObject var viewModel = TaskViewViewModel.shared
    
    return TaskModalView(viewModel: viewModel)
}
