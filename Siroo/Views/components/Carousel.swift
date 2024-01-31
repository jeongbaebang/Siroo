//
//  Carousel.swift
//  Siroo
//
//  Created by jeongbae bang on 1/27/24.
//

import SwiftUI
import UIKit

struct Carousel<Content: View, List: RandomAccessCollection>: View where List.Element: Identifiable {
    private let PagingControlOffsetY: CGFloat = 120
    var list: List
    var itemWidth: CGFloat
    @Binding var activeID: UUID?
    @ViewBuilder var content: (List.Element, Bool) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(list) { item in
                            let isFocused = isItemFocused(item)
                            
                            content(item, isFocused)
                                .frame(width: itemWidth)
                                .scrollTransition { content, phase in
                                    content
                                        .scaleEffect(
                                        x: determineScaleEffect(phase.isIdentity),
                                        y: determineScaleEffect(phase.isIdentity)
                                    )
                                }
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, (size.width - itemWidth) / 2)
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $activeID, anchor: .center)
                
                PagingControl(numberOfPages: list.count, activePage: activePage)
                    .offset(y: PagingControlOffsetY)
            }
        }
    }
    
    private func determineScaleEffect(_ isIdentity: Bool) -> Double {
        let scalePoint = 1.5
        let scaleDefault = 0.5
        
        return isIdentity ? scalePoint : scaleDefault
    }
    
    private func isItemFocused(_ item: List.Element) -> Bool {
        /// 아이디가 없으면 첫번째 요소 반환
        if activeID == nil {
            return item.id == list.first?.id
        }
        
        return item.id == activeID as? List.Element.ID
    }
    
    private var activePage: Int {
        if let index = list.firstIndex(where: { $0.id as? UUID == activeID }) as? Int {
            return index
        }
        
        return 0
    }
}

struct PagingControl: UIViewRepresentable {
    var numberOfPages: Int
    var activePage: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPage = activePage
        pageControl.numberOfPages = numberOfPages
        pageControl.backgroundStyle = .prominent
        pageControl.currentPageIndicatorTintColor = UIColor(Color.primary)
        pageControl.pageIndicatorTintColor = UIColor.placeholderText
        
        return pageControl
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.numberOfPages = numberOfPages
        uiView.currentPage = activePage
    }
}

struct ParentView: View {
    @State var scrolledID: UUID?
    @State var items: [TaskItem] = [
        .init(systemName: "heart.fill", label: "작업#1"),
        .init(systemName: "heart.fill", label: "작업#2"),
        .init(systemName: "heart.fill", label: "작업#3"),
        .init(systemName: "heart.fill", label: "작업#4"),
        .init(systemName: "heart.fill", label: "작업#5"),
        .init(systemName: "heart.fill", label: "작업#6")
    ]
    
    init() {
        if let firstItemID = items.first?.id {
            _scrolledID = State(initialValue: firstItemID)
        }
    }
    
    var body: some View {
        Carousel(list: items, itemWidth: 200, activeID: $scrolledID) { item, isFocused in
            TaskItemView(systemName: item.systemName, label: item.label, isFocused: isFocused)
        }
    }
}

#Preview {
    ParentView()
}

