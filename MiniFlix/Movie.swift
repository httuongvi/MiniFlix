//
//  Movie.swift
//  MiniFlix
//
//  Created by Tuong Vi on 8/7/26.
//

import Foundation
import SwiftData

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
    var releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}

@Model
class FavoriteMovieItem{
    @Attribute(.unique) var id: Int
    var title: String
    var overview: String
    var posterPath: String?
    var voteAverage: Double
    var releaseDate: String?
    var timestamp: Date
    
    init(id: Int, title: String, overview: String, posterPath: String? = nil, voteAverage: Double, releaseDate: String? = nil) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
        self.timestamp = Date()
    }
    
}
