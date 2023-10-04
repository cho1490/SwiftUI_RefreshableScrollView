//
//  RefreshableScrollView.swift
//
//  Created by 조상현 on 2023/03/16.
//

import SwiftUI

struct RefreshableScrollView<Content: View>: View {
            
    @Binding var hasNextPage: Bool
    @Binding var isLoading: Bool
    @ViewBuilder let content: () -> Content
    let completion: (LoadType) -> Void

    enum LoadType {
        case Reload
        case LoadMore
    }

    // Reload, LoadMore 호출하기 위한 스크롤 감도
    let sensitivity: CGFloat = 100
    
    @State private var reloadData: Bool = false
    @State private var leadMoreData: Bool = false
    
    @State private var scrollViewSize: CGFloat = 0
    @State private var startOffset: CGFloat = 0
        
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    if reloadData {
                        ZStack {
                            getLoadingView()
                        }
                        .onAppear {
                            completion(.Reload)
                        }
                    }
                    
                    content()
                        .onChange(of: isLoading) { _ in
                            if !isLoading {
                                reloadData = false
                                leadMoreData = false
                            }
                        }
                    
                    if hasNextPage && leadMoreData {
                        ZStack {
                            getLoadingView()
                        }
                        .onAppear {
                            completion(.LoadMore)
                        }
                    }
                }
                .overlay(
                    GeometryReader { proxy -> Color in
                        DispatchQueue.main.async {
                            if startOffset == 0 {
                                self.startOffset = proxy.frame(in: .global).minY
                            }
                            let contentSize = proxy.size.height
                                                           
                            let offset = proxy.frame(in: .global).minY
                            let scrollViewOffset = offset - startOffset
                            
                            // Top Refresh
                            if scrollViewOffset >= sensitivity {
                                reloadData = true
                            }
                            
                            // Bottom Refresh
                            // 스크롤 뷰 내부 컨텐츠가 스크롤 뷰 보다 사이즈가 작을 경우
                            if contentSize < scrollViewSize {
                                if scrollViewOffset < -sensitivity {
                                    leadMoreData = true
                                }
                            } else {
                                if abs(scrollViewOffset) + scrollViewSize > contentSize + sensitivity {
                                    leadMoreData = true
                                }
                            }
                        }
                        
                        return Color.clear
                    }
                )
            } // ScrollView
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            scrollViewSize = proxy.size.height
                        }
                }
            )
            .scrollDisabled(isLoading) // 로딩중일 때 스크롤 방지
        } // ZStack
    }
    
    func getLoadingView() -> some View {
        Group {
            if isLoading {
                ProgressView().frame(width: 40, height: 40)
            } else {
                EmptyView()
            }
        }
    }
    
}
