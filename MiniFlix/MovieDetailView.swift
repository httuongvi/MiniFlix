//
//  MovieDetailView.swift
//  MiniFlix
//
//  Created by Tuong Vi on 14/7/26.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    var body: some View {
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
        }
        .padding(20)
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("Detail \(movie.title)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // Bọc trong NavigationStack để hiển thị navigationTitle
    NavigationStack {
        MovieDetailView(movie: Movie(
            id: 1,
            title: "The Dark Knight",
            overview: "Batman đối đầu Joker, tên tội phạm muốn nhấn chìm Gotham vào hỗn loạn.",
            posterPath: nil,
            voteAverage: 9.0
        ))
    }
}
