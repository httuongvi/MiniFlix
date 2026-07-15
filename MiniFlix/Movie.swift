//
//  Movie.swift
//  MiniFlix
//
//  Created by Tuong Vi on 8/7/26.
//

import Foundation

struct Movie: Identifiable, Codable {
    let id = UUID()
    var title: String
    var overview: String
    var posterPath: String?
    var voteAverage: Double
    var isFavorite: Bool = false
}
