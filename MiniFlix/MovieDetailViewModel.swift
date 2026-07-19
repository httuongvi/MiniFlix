//
//  MovieDetailViewModel.swift
//  MiniFlix
//
//  Created by Tuong Vi on 19/7/26.
//

import Foundation
import SwiftData
import Observation

@Observable
class MovieDetailViewModel{
    
    func toggleFavorite(modelContext: ModelContext, movie: FavoriteMovieItem, isFavorite: Bool, favoriteMovies: [FavoriteMovieItem]) {
        
        if isFavorite {
            if let itemDelete = favoriteMovies.first(where: { $0.id == movie.id }) {
                modelContext.delete(itemDelete)
            }
        } else {
            let newFavorite = FavoriteMovieItem(
                id: movie.id,
                title: movie.title,
                overview: movie.overview,
                posterPath: movie.posterPath,
                voteAverage: movie.voteAverage
            )
            modelContext.insert(newFavorite)
        }
        
        do {
            try modelContext.save()
            print("Đã lưu thành công")
        } catch {
            print(error)
        }
    }
}
