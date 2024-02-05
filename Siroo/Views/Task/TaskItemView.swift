//
//  TaskItem.swift
//  Siroo
//
//  Created by jeongbae bang on 1/24/24.
//

import SwiftUI

struct TaskItemView: View {
    var systemName: String
    var label: String
    var isFocused: Bool = false
    private let circleSize: CGFloat = 95
    private let CircleBorderSize: CGFloat = 4
    private let imageSize: CGFloat = 40
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.regularMaterial)
                    .strokeBorder(isFocused ? Color.green : Color.clear, lineWidth: CircleBorderSize)
                    .animation(.spring, value: isFocused)
                    .frame(width: circleSize, height: circleSize)
                
                Image(systemName: systemName)
                    .font(.system(size: imageSize))
                    .accessibilityLabel("\(label) 아이콘")
            }
            
            Text(label)
                .font(.body)
                .lineLimit(1)
                .bold(isFocused)
                .accessibilityLabel(label)
        }
    }
}

#Preview {
    HStack {
        TaskItemView(systemName: "heart.fill", label: "작업#1")
    }
}
