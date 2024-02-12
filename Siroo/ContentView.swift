//
//  ContentView.swift
//  Siroo
//
//  Created by jeongbae bang on 1/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TaskView()
                .tabItem {
                    Label("작업", systemImage: "timer")
                }
            ChartView()
                .tabItem {
                    Label("작업현황", systemImage: "chart.bar.fill")
                }
        }
        .on
    }
}

#Preview {
    ContentView()
}
