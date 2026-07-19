//
//  MovieDetailView.swift
//  MiniFlix
//
//  Created by Tuong Vi on 14/7/26.
//

import SwiftUI
import SwiftData

struct MovieDetailView: View {
    let movie: FavoriteMovieItem
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var favoriteMovies: [FavoriteMovieItem]
    
    @State private var viewModel: MovieDetailViewModel = MovieDetailViewModel()
    
    
    var body: some View {
        let isFavorite = favoriteMovies.contains(where: { $0.id == movie.id })
        VStack{
            Text(movie.title)
                .font(.largeTitle)
                .bold()
            
            
            if let posterPath = movie.posterPath {
                let urlPoster = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
                
                AsyncImage(url: urlPoster) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 250, height: 300)
                            .foregroundColor(.gray.opacity(0.3))
                    case .success(let img):
                        img
                            .resizable()
                            .frame(width: 250, height: 300)
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 200))
                            .frame(width: 250, height: 300)
                            .background(.gray.opacity(0.3))
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "film")
                    .font(.system(size: 200))
                    .frame(width: 250, height: 300)
                    .background(.gray.opacity(0.3))
            }
            
            
            
            Text(movie.overview)
                .font(.body)
            
            HStack(alignment: .center, spacing: 10){
                Text("\(String(format: "%.1f",movie.voteAverage))/10")
                    .font(.headline)
                    .bold()
                Image(systemName: "star.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.yellow)
            }
            
            Spacer()
            
            Button(action: {viewModel.toggleFavorite(modelContext: modelContext, movie: movie, isFavorite: isFavorite, favoriteMovies: favoriteMovies )}
                ){
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
                    .font(.system(size: 30))
            }
            .padding(10)
            .frame(width: 100, height: 50)
            .background(Color.pink.opacity(0.2))
            .cornerRadius(10)
            
            
        }
        .padding(20)
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("Detail \(movie.title)")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    NavigationStack {
        MovieDetailView(movie: FavoriteMovieItem(
            id: 1,
            title: "The Dark Knight",
            overview: "Batman đối đầu Joker, tên tội phạm muốn nhấn chìm Gotham vào hỗn loạn.",
            posterPath: nil,
            voteAverage: 9.0
        ))
        .modelContainer(for: FavoriteMovieItem.self)
    }
}
