//
//  MovieListViewModel.swift
//  MiniFlix
//
//  Created by Tuong Vi on 16/7/26.
//

import Foundation
import Observation

enum LoadState {
    case idle
    case loading
    case loaded([Movie])
    case empty
    case error(String)
    
}


@Observable
class MovieListViewModel{
    private var service = TMDBService()
    
    private(set) var state: LoadState = .idle
    
    var searchQuery: String = ""
    
    func loadPopularMovies() async {
        
        guard case .idle = state else {
            return
        }

        state = .loading
        
        do{
            let fetchedMovies = try await service.fetchPopular()
            
            if fetchedMovies.isEmpty{
                state = .empty
            } else {
                state = .loaded(fetchedMovies)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func deleteMovie(_ movie: Movie) {
        if case .loaded(var currentMovies) = state {
            if let index = currentMovies.firstIndex(where: {$0.id == movie.id}){
                currentMovies.remove(at: index)
                
                if currentMovies.isEmpty{
                    state = .empty
                } else{
                    state = .loaded(currentMovies)
                }
            }
        }
    }

    func toggleFavorite(_ movie: Movie) {
        if case .loaded(var currentMovies) = state{
            if let index = currentMovies.firstIndex(where: {$0.id == movie.id}){
                currentMovies[index].isFavorite.toggle()
                
                state = .loaded(currentMovies)
            }
        }
    }
        
    
    
    @MainActor
    func onSearch() async {
        guard !searchQuery.isEmpty else {
            return
        }
        
        if case .loading = state {
            return
        }
        state = .loading
        
        do{
            let fetchedMovies = try await service.searchMovies(query: searchQuery)
            
            if fetchedMovies.isEmpty{
                state = .empty
            } else {
                state = .loaded(fetchedMovies)
            }
        }catch {
            state = .error(error.localizedDescription)
        }
    }
    
    @MainActor
    func refresh() async{
        state = .loading
        
        do{
            let fetchedMovies = try await service.fetchPopular()
            
            if fetchedMovies.isEmpty{
                state = .empty
            } else {
                state = .loaded(fetchedMovies)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
}
