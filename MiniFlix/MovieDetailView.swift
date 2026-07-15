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
            
            Image(systemName: "film")
                .font(.system(size: 200))
                .frame(width: 250, height: 300)
                .background(.gray.opacity(0.3))
            
            Text(movie.overview)
                .font(.body)
            
            HStack(alignment: .center, spacing: 10){
                Text("\(String(movie.voteAverage))/10")
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
            title: "The Dark Knight",
            overview: "Batman đối đầu Joker, tên tội phạm muốn nhấn chìm Gotham vào hỗn loạn.",
            posterPath: nil,
            voteAverage: 9.0
        ))
    }
}
