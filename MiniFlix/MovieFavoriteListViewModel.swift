//
//  MovieFavoriteListViewModel.swift
//  MiniFlix
//
//  Created by Tuong Vi on 19/7/26.
//

import Foundation
import Observation
import SwiftData

@Observable
class MovieFavoriteListViewModel{
    func deleteMovie(
        _ movie: FavoriteMovieItem,
        modelContext: ModelContext
    ) {
        modelContext.delete(movie)

        do {
            try modelContext.save()
            print("Đã lưu thành công")
        } catch {
            print(error)
        }
    }
    
}
