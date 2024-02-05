//
//  TaskModalView.swift
//  Siroo
//
//  Created by jeongbae bang on 2/1/24.
//

import SwiftUI

struct TaskModalView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TaskViewViewModel
    @State private var currentLabel: String
    @State private var currentIcon: TaskIcon.Icon
    
    init(viewModel: TaskViewViewModel) {
        self.viewModel = viewModel
        // viewModel의 activeItem.systemName을 기반으로 draftProfivle 초기값 설정
        let initialIcon = TaskIcon.Icon.allCases.first(where: { $0.rawValue == viewModel.activeItem.systemName }) ?? TaskIcon.Icon.heart
        self._currentIcon = State(initialValue: initialIcon)
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
        Grabbar()
        
        HStack {
            Text("편집")
                .font(.title3)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
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
        VStack {
            HStack {
                Text("Label")
                
                Spacer()
                
                TextField("아이콘 설명을 입력해주세요.", text: $currentLabel)
                    .multilineTextAlignment(.center)
                    .padding(.trailing, 20)
                
                Button(action: {
                    currentLabel = ""
                }, label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.secondary)
                })
            }
            .padding()
            .background(.regularMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
    
    @ViewBuilder
    func IconPicker() -> some View {
        Picker("IconPicker", selection: $currentIcon) {
            ForEach(TaskIcon.Icon.allCases) { icon in
                Image(systemName: icon.rawValue).tag(icon)
            }
        }
        .pickerStyle(.palette)
        .padding()
        .onChange(of: currentIcon) { oldValue, newValue in
            viewModel.updateTaskItem(for: \.systemName, with: newValue.rawValue)
        }
        .onDisappear(perform: {
            viewModel.updateTaskItem(for: \.label, with: currentLabel)
        })
    }
}

#Preview {
    @StateObject var viewModel = TaskViewViewModel()
    
    return TaskModalView(viewModel: viewModel)
}
