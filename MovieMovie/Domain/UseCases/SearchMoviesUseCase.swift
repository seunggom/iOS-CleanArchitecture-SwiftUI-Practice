//
//  SearchMoviesUseCase.swift
//  MovieMovie
//
//  Created by SeungYeon Kim on 2023/01/06.
//

import Foundation

protocol SearchMoviesUseCase {
    func execute(searchKeyword value: String, completion: @escaping (Result<[Movie], ClientError>) -> Void) async
}

class SearchMoviesDefaultUseCase: SearchMoviesUseCase {
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(searchKeyword value: String, completion: @escaping (Result<[Movie], ClientError>) -> Void) async {
        await movieRepository.searchMovies(keyword: value, completion: completion)
    }
    
    
}
