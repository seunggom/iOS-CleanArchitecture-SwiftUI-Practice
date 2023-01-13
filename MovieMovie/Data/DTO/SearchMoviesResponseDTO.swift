//
//  SearchMoviesDTO.swift
//  MovieMovie
//
//  Created by SeungYeon Kim on 2023/01/09.
//

import Foundation

class SearchMoviesResponseDTO: Decodable {
    let total: Int
    let items: [SearchedMovieItem]
}


struct SearchedMovieItem: Decodable {
    let title: String
    let link: String
    let image: String
    let subtitle: String
    let pubDate: String
    let director: String
    let actor: String
    let userRating: String
}
