//
//  ContentView.swift
//  SwiftUIInfinityScrollView
//
//  Created by 조상현 on 2023/03/16.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
  
    var body: some View {
        VStack {
            Text("SwiftUI Infinity Scroll View")
                                               
            RefreshableScrollView(hasNextPage: $viewModel.hasNextPage, isLoading: $viewModel.isLoading) {
                // TODO: UIKit TableView
                ForEach(0..<viewModel.data.list.count, id: \.self) { index in
                    // TODO: UIKit TableView Cell
                    Text(viewModel.data.list[index].text)
                        .frame(height: 100)
                }
            } completion: { loadType in
                // TODO: Refresh Action Implementation
                if loadType == .Reload {
                    viewModel.getFirstData()
                } else if loadType == .LoadMore {
                    viewModel.getData()
                }
            }
        }
        .onAppear {
            viewModel.getData()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
    
}
