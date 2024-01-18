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

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .foregroundStyle(isDisabled ? .gray : color)
                .font(.body)
                .fontWeight(.regular)
                .frame(width: 206, alignment: .center)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .disabled(isDisabled)
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomButton(title: "작업 시작", systemImage: "arrowtriangle.right.fill", color: .green, isDisabled: false) { }
        
        CustomButton(title: "작업 일시정지", systemImage: "stop.fill", color: .red, isDisabled: false) { }
        
        CustomButton(title: "작업 종료", systemImage: "stopwatch.fill", color: .blue, isDisabled: true) { }
    }
}
