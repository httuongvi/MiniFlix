//
//  ContentView.swift
//  MiniFlix
//
//  Created by Tuong Vi on 7/7/26.
//

import SwiftUI

struct ContentView: View {
    let movieSample: Movie = Movie(
        title: "Movie 1",
        overview: "Movie 1 is very exciting Movie 1 is very exciting Movie 1 is very exciting Movie 1 is very exciting Movie 1 is very exciting Movie 1 is very exciting Movie 1 is very exciting",
        posterPath: nil,
        voteAverage: 3.5
        
    )
    var body: some View {
        MovieCardView(movie: movieSample)
    }
}

struct MovieCardView: View{
    let movie: Movie
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "film")
                    .font(.system(size: 60))
                
                VStack{
                    Text(movie.title)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(movie.overview)
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        
                }
                .padding(2)
                
                HStack (spacing: 2){
                    Text(String(movie.voteAverage))
                        .font(.headline)
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                    
            }
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            Spacer()
        }
                 
                 
    }
}

#Preview {
    ContentView()
}
