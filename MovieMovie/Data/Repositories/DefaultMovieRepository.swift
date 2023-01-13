//
//  DefaultMovieRepository.swift
//  MovieMovie
//
//  Created by SeungYeon Kim on 2023/01/09.
//

import Foundation

class DefaultMovieRepository: MovieRepository {
    private let remoteDataSource: RemoteDataSource
    
    init(remoteDataSource: RemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func searchMovies(keyword: String, completion: (Result<[Movie], ClientError>) -> Void) async {
        do {
            try await remoteDataSource.searchMovies(keyword: keyword) { result in
                switch result {
                case .success(let responseDTO):
                    completion(Result.success(responseDTO.items.map {
                        Movie(title: $0.title,
                              thumbnailImage: $0.image,
                              pubDate: $0.pubDate,
                              actors: ($0.actor).components(separatedBy: "|"),
                              userRating: $0.userRating,
                              link: $0.link)
                    }))
                case .failure(let error):
                    completion(Result.failure(ClientError(message: error.errorReason)))
                }
            }
        } catch {
            completion(Result.failure(ClientError(message: "Unknown")))
        }
    }
    
    
}
