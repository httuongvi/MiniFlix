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
    
    func loadPopularMovies(force: Bool) async {
        if !force {
            guard case .idle = state else {
                return
            }
        }
        print("Đang load popular")
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
        
    
    
    @MainActor
    func onSearch() async {
        guard !searchQuery.isEmpty else {
            return
        }
        
        if case .loading = state {
            return
        }
        print("Đang load search")
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
        if searchQuery.isEmpty{
            await loadPopularMovies(force: true)
        } else {
            await onSearch()
        }
    }
    
}
