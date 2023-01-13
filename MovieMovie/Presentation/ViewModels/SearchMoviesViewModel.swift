//
//  SearchMoviesViewModel.swift
//  MovieMovie
//
//  Created by SeungYeon Kim on 2023/01/09.
//

import Foundation
import Combine

// https://wayneyuhanhsiao.wordpress.com/2021/09/23/modern-ios-mvvm-view-model-input-output-state-machine-using-feedback-loop/

enum SearchMoviesViewState {
    case onWaiting
    case loading
    case failed(ClientError)
    case loaded([MovieListItem])
}

protocol SearchMoviesInput {
    func search(keyword: String) async
    func showDetail(movie: String) async
}

protocol SearchMoviesOutput {
    var state: SearchMoviesViewState { get }
}

class SearchMoviesViewModel: ObservableObject, SearchMoviesInput, SearchMoviesOutput {
    private let searchMoviesUseCase = SearchMoviesDefaultUseCase(movieRepository: DefaultMovieRepository(remoteDataSource: RemoteDataSource()))
    
    @Published var state: SearchMoviesViewState = .onWaiting
    
    func search(keyword: String) async {
        await searchMoviesUseCase.execute(searchKeyword: keyword) { result in
            switch result {
            case .success(let movies):
                let items = movies.map { movie in
                    MovieListItem(id: movie.title.hashValue, title: movie.title)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.state = .loaded(items)
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.state = .failed(ClientError(message: error.message))
                }
            }
        }
    }
    
    func showDetail(movie: String) async {
        
    }
    
    
    
}
