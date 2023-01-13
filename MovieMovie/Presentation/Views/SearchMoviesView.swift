//
//  ContentView.swift
//  MovieMovie
//
//  Created by SeungYeon Kim on 2023/01/04.
//

import SwiftUI

struct SearchMoviesView: View {
    @ObservedObject var viewModel = SearchMoviesViewModel()
    
    @State private var searchKeyword: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("키워드를 입력하여 영화를 검색하세요.", text: $searchKeyword)
                    .padding(20)
                    .border(.secondary)
                    .padding(.horizontal, 10)
                Button("검색하기") {
                    Task {
                        await viewModel.search(keyword: searchKeyword)
                    }
                }
                switch viewModel.state {
                case .loaded(let items):
                    List(items) { item in
                        Text(item.title)
                    }
                default:
                    EmptyView()
                }
            }
            .navigationTitle("title!!")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMoviesView()
    }
}
