//
//  MovieRepository.swift
//  MovieMovie
//
//  Created by SeungYeon Kim on 2023/01/06.
//

import Foundation

protocol MovieRepository {
    func searchMovies(keyword: String, completion: (Result<[Movie], ClientError>) -> Void) async
}
