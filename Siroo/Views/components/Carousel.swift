//
//  Carousel.swift
//  Siroo
//
//  Created by jeongbae bang on 1/27/24.
//

import SwiftUI
import UIKit

struct Carousel<Content: View, List: RandomAccessCollection>: View where List.Element: Identifiable {
    var list: List
    var itemWidth: CGFloat
    @Binding var activeID: UUID?
    @Binding var lastActiveID: UUID?
    @ViewBuilder var content: (List.Element, Bool) -> Content
    @State private var hasLastActiveID: Bool = false
    private let pagingControlOffsetY: CGFloat = 120
    
    var body: some View {
        GeometryReader {
            let paddingSpacing = ($0.size.width - itemWidth) / 2
            
            ZStack {
                ScrollViewReader { proxy in
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
                        .padding(.horizontal, paddingSpacing)
                    }
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $activeID, anchor: .center)
                    .onAppear(perform: {
                        if let lastActiveID {
                            hasLastActiveID = true
                            let itemIndex = indexCalibration(activeID: lastActiveID)
                            
                            if itemIndex >= 0 {
                                let targetItemID = list[itemIndex as! List.Index].id
                                
                                proxy.scrollTo(targetItemID, anchor: .zero)
                            }
                        }
                    })
                    .onChange(of: activeID) { _, newValue in
                        if lastActiveID != nil {
                            hasLastActiveID = false
                            lastActiveID = nil
                        }
                    }
                }
                PagingControl(numberOfPages: list.count, activePage: activePageIndex)
                    .offset(y: pagingControlOffsetY)
            }
        }
    }
    
    private func determineScaleEffect(_ isIdentity: Bool) -> Double {
        let scalePoint = 1.5
        let scaleDefault = 0.5
        
        return isIdentity ? scalePoint : scaleDefault
    }
    
    private func getCurrentActiveID() -> UUID? {
        return hasLastActiveID ? lastActiveID : activeID
    }
    
    private func getTargetIndex(id: UUID?) -> Int {
        let firstIndex = 0
        
        if let index = list.firstIndex(where: { $0.id as? UUID == id }) as? Int {
            return index
        }
        
        return firstIndex
    }
    
    private func isItemFocused(_ item: List.Element) -> Bool {
        let targetID = getCurrentActiveID()
        
        /// 아이디가 없으면 첫번째 요소 반환
        if hasLastActiveID == false, activeID == nil {
            return item.id == list.first?.id
        }
        
        return item.id == targetID as? List.Element.ID
    }
    
    private func indexCalibration(activeID: UUID) -> Int {
        let maxWidth: CGFloat = 400
        let screenWidth = UIScreen.main.bounds.width
        let itemIndex = getTargetIndex(id: activeID)
        
        if screenWidth > maxWidth {
            return itemIndex - 1
        }
        
        return itemIndex
    }
    
    private var activePageIndex: Int {
        let targetID = getCurrentActiveID()
        
        return getTargetIndex(id: targetID)
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
    @State var lastActiveID: UUID?
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
        Carousel(list: items, itemWidth: 200, activeID: $scrolledID,lastActiveID: $lastActiveID) { item, isFocused in
            TaskItemView(systemName: item.systemName, label: item.label, isFocused: isFocused)
        }
    }
}

#Preview {
    ParentView()
}

