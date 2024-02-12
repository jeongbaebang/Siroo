//
//  ChartView.swift
//  Siroo
//
//  Created by jeongbae bang on 2/7/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    @ObservedObject var viewModel = TaskViewViewModel.shared
    
    private var recordList: [ActivityRecord] {
        return viewModel.activityRecordList
    }
    @State private var graphType: GraphType = .bar
    @State private var barSelection: String?
    
    var body: some View {
        VStack {
            showChartInfoWithAlert()
                
            Picker("graphType", selection: $graphType) {
                ForEach(GraphType.allCases) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)
            
            
            TopRecordDisplayView()
            
            if recordList.isEmpty {
                EmptyChart()
            } else {
                if graphType == .bar {
                    BarChart()
                }
                
                if graphType == .list {
                    ListChart()
                }
            }
            
            Spacer()
        }
        .padding()
        .animation(graphType == .bar ? .snappy : .none, value: graphType)
    }
    
    @ViewBuilder
    func showChartInfoWithAlert() -> some View {
        let leftIcon = ("Chart", "chart.bar.fill")
        let rightIcon = ("요일별로 데이터가 초기화됩니다.", "exclamationmark.triangle.fill")
        
        HStack {
            Label(leftIcon.0, systemImage: leftIcon.1)

            Spacer()
            
            Label(
                title: {
                    Text(rightIcon.0)
                },
                icon: {
                    Image(systemName: rightIcon.1)
                }
            )
            .font(.caption)
            .foregroundStyle(.gray)
        }
    }
    
    @ViewBuilder
    func TopRecordDisplayView() -> some View {
        let emptyString = " "
        let title = "가장 높은 작업시간"
        
        HStack(alignment: .firstTextBaseline) {
            Text((barSelection != nil) ? emptyString : title)
                .font(.title3)
                .fontWeight(.bold)
            
            Spacer()
        }
        .padding(.top)
        .animation(.interactiveSpring, value: barSelection)
        
        ZStack {
            if let highestRecord = recordList.max(by: {
                $1.secondsElapsed > $0.secondsElapsed
            }) {
                ChartPopOverView(highestRecord.label, highestRecord.secondsElapsed, isTitleView: true)
                    .opacity(barSelection == nil ? 1 : 0)
            }
        }
    }
    
    @ViewBuilder
    func ListChart() -> some View {
        VStack {
            List(recordList) { record in
                Section(record.label) {
                    HStack {
                        Image(systemName: record.systemName.rawValue)
                        Text(formatTime(seconds: record.secondsElapsed))
                    }
                }
            }
            .listStyle(.plain)
            .background(Color.clear)
        }
    }
    
    @ViewBuilder
    func EmptyChart() -> some View {
        let text = "측정된 작업이 없습니다."
        
        Spacer()
        Text(text)
            .fontWeight(.bold)
            .padding()
    }
    
    @ViewBuilder
    func BarChart() -> some View {
        let frameHeight: CGFloat = 300
        let chartSpacing: CGFloat = 25
        let color = Color("PopupColor")
        
        Chart {
            let radius: CGFloat = 8
            
            ForEach(recordList) { record in
                    BarMark(
                        x: .value("label", record.label),
                        y: .value("work Time", record.secondsElapsed)
                    )
                    .cornerRadius(radius)
                    .foregroundStyle(by: .value("label", record.label))
            }
            
            if let barSelection {
                let zIndex: Double = -1
                let offset: (CGFloat, CGFloat) = (-7.5, -1)
                
                RuleMark(x: .value("lable", barSelection))
                    .zIndex(zIndex)
                    .offset(yStart: offset.0, yEnd: offset.1)
                    .annotation(
                        position: .top,
                        spacing: 0,
                        overflowResolution: .init(x: .fit, y: .disabled)) {
                            if let record = recordList.findRecord(barSelection) {
                                ChartPopOverView(barSelection, record.secondsElapsed)
                            }
                        }
                        .foregroundStyle(color)
            }
        }
        .chartXSelection(value: $barSelection)
        .chartLegend(position: .bottom, alignment: .leading, spacing: chartSpacing)
        .frame(height: frameHeight)
    }
    
    @ViewBuilder
    func ChartPopOverView(_ labelName: String, _ seconds: Int, isTitleView: Bool = false) -> some View {
        let spacing: CGFloat = 4
        let radius: CGFloat = 8
        let color = Color("PopupColor")
        
        VStack(alignment: .leading, spacing: spacing) {
            Text(labelName)
                .font(.headline)
                .foregroundStyle(.gray)
            
            Text("\(formatTime(seconds: seconds))")
                .font(.title3)
                .fontWeight(.semibold)
        }
        .padding([.all])
        .background(color.opacity(isTitleView ? 0 : 1), in: .rect(cornerRadius: radius))
        .frame(maxWidth: .infinity, alignment: isTitleView ? .leading : .center)
    }
}


#Preview {
    ChartView()
}
