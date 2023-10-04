//
//  ContentViewModel.swift
//  SwiftUIInfinityScrollView
//
//  Created by 조상현 on 2023/03/16.
//

import Foundation

class ContentViewModel: ObservableObject {
            
    @Published var data: ListData = ListData()
    
    @Published var hasNextPage: Bool = false
    @Published var isLoading: Bool = false
    
    func getFirstData() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [self] in
            // 리셋
            data = ListData()
            
            for _ in 0..<2 {
                let model = Model(text: "item number : \(data.list.count + 1)")
                data.list.append(model)
            }
            
            data.current_page = "1"
            data.total_page = "2"
            hasNextPage = data.current_page < data.total_page
            
            isLoading = false
        }        
    }
    
    func getData() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [self] in
            for _ in 0..<2 {
                let model = Model(text: "item number : \(data.list.count + 1)")
                data.list.append(model)
            }
            
            data.current_page = "1"
            data.total_page = "2"
            hasNextPage = data.current_page < data.total_page
            
            isLoading = false
        }
    }
     
}
