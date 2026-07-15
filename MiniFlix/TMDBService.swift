//
//  TMDBService.swift
//  MiniFlix
//
//  Created by Tuong Vi on 15/7/26.
//

import Foundation

class TMDBService {
    private let apiKey: String = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNzIzN2FmZmYwM2NiMjQyMzM4ZmQ4MDc0Y2FiYjI0ZiIsIm5iZiI6MTc4MjcyMTI4Ny40NjEsInN1YiI6IjZhNDIyYjA3YTJkMTE0MDE4NmY2ODUyYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.KdSJAwgQFkUu76iyxeV9To2f9bXJ39_aMc5xM2sZqmE"
    private let baseURL: String = "https://api.themoviedb.org/3"
    
    
    func createRequest(for url: URL) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "accept")
        return request
    }
    
    func fetchPopular() async throws -> [Movie] {
        let urlString = "\(baseURL)/movie/popular"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let request = createRequest(for: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            throw NetworkError.serverError(statusCode: statusCode)
        }
        
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(TMDBResponse.self, from: data)
        return decodedData.results
        
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        guard let encodeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/search/movie?query=\(encodeQuery)")
        else {
            throw URLError(.badURL)
        }
        
        let request = createRequest(for: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            throw NetworkError.serverError(statusCode: statusCode)
        }
        
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(TMDBResponse.self, from: data)
        return decodedData.results
    }
}

enum NetworkError: Error {
    case noInternet
    case serverError(statusCode: Int)
    case decodeFailed
    case invalidURL
}
