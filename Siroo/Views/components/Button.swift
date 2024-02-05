//
//  Button.swift
//  Siroo
//
//  Created by jeongbae bang on 1/18/24.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let systemImage: String
    let color: Color
    let isDisabled: Bool
    let action: () -> Void
    let buttonWidth: CGFloat = 206
    
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .foregroundStyle(isDisabled ? .gray : color)
                .font(.body)
                .fontWeight(.regular)
                .frame(width: buttonWidth, alignment: .center)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .disabled(isDisabled)
    }
}

struct CancelButton: View {
    let buttonSize: CGFloat = 30
    
    var body: some View {
        Image(systemName: "xmark.circle.fill")
            .resizable()
            .frame(width: buttonSize, height: buttonSize)
            .foregroundColor(.gray)
            .symbolRenderingMode(.hierarchical)
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomButton(title: "작업 시작", systemImage: "arrowtriangle.right.fill", color: .green, isDisabled: false) {}
        
        CustomButton(title: "작업 일시정지", systemImage: "stop.fill", color: .red, isDisabled: false) {}
        
        CustomButton(title: "작업 종료", systemImage: "stopwatch.fill", color: .blue, isDisabled: true) {}
    }
}
