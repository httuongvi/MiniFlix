//
//  Movie.swift
//  MiniFlix
//
//  Created by Tuong Vi on 8/7/26.
//

import Foundation

struct TMDBResponse: Codable {
    let results: [Movie]
}

struct Movie: Identifiable, Codable {
    let id: Int
    var title: String
    var overview: String
    var posterPath: String?
    var voteAverage: Double
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
