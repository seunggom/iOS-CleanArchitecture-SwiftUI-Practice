//
//  RemoteDataSource.swift
//  MovieMovie
//
//  Created by SeungYeon Kim on 2023/01/09.
//

import Foundation

class RemoteDataSource {
    private let httpService: HttpService = HttpService(url: "https://openapi.naver.com/v1")
        
    func searchMovies(keyword: String, complete: (Result<SearchMoviesResponseDTO, HttpError>) -> Void) async throws {
        try await httpService.request(method: .GET, endpoint: "/search/movie.json", complete: complete)
    }
}
