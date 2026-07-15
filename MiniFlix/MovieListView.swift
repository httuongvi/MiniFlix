//
//  MovieListView.swift
//  MiniFlix
//
//  Created by Tuong Vi on 14/7/26.
//

import SwiftUI
struct MovieCardView: View{
    let movie: Movie
    let onDelete: (Movie) -> Void
    let onFavorite: (Movie) -> Void
    var body: some View {
        let _ = Self._printChanges()
        VStack{
            HStack{
                Image(systemName: "film")
                    .font(.system(size: 40))
                    .frame(width: 70, height: 100)
                    .background(.gray.opacity(0.3))
                
                
                VStack(alignment: .leading, spacing: 6){
                    Text(movie.title)
                        .font(.headline)
                        .bold()
                        .lineLimit(1)
                    
                    Text(movie.overview)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if movie.isFavorite{
                    VStack(){
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 15)
                    
                }
                
                HStack (spacing: 2){
                    Text(String(movie.voteAverage))
                        .font(.headline)
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                    
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 3)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                onDelete(movie)
            } label: {
                Label("Xoá", systemImage: "trash")
            }
        }
        
        .swipeActions(edge: .leading){
            Button {
               onFavorite(movie)
            } label: {
                Label(
                    movie.isFavorite ? "Bỏ thích" : "Thích",
                    systemImage: movie.isFavorite ? "heart.slash" : "heart"
                )
            }
            .tint(.pink)
        }
                 
                 
    }
}

struct MovieListView: View {
    @State private var movieSamples: [Movie] = [
        Movie(
            title: "The Dark Knight",
            overview: "Batman faces the Joker, a criminal mastermind who wants to plunge Gotham City into chaos.",
            posterPath: nil,
            voteAverage: 9.0
        ),
        Movie(
            title: "Inception",
            overview: "A skilled thief enters people's dreams to steal secrets but is given one final impossible mission.",
            posterPath: nil,
            voteAverage: 6.8
        ),
        Movie(
            title: "Interstellar",
            overview: "A team of astronauts travels through a wormhole in search of a new home for humanity.",
            posterPath: nil,
            voteAverage: 8.7
        ),
        Movie(
            title: "Avengers: Endgame",
            overview: "The Avengers assemble for one final battle to undo the devastation caused by Thanos.",
            posterPath: nil,
            voteAverage: 8.4
        ),
        Movie(
            title: "Parasite",
            overview: "A poor family gradually infiltrates the lives of a wealthy household with unexpected consequences.",
            posterPath: nil,
            voteAverage: 8.6
        ),
        Movie(
            title: "Spider-Man: No Way Home",
            overview: "Peter Parker seeks help from Doctor Strange, leading to unexpected multiverse events.",
            posterPath: nil,
            voteAverage: 8.3
        ),
        Movie(
            title: "The Shawshank Redemption",
            overview: "A banker imprisoned for a crime he didn't commit forms a lasting friendship and never loses hope.",
            posterPath: nil,
            voteAverage: 9.3
        ),
        Movie(
            title: "The Matrix",
            overview: "A hacker discovers the shocking truth about reality and joins the fight against intelligent machines.",
            posterPath: nil,
            voteAverage: 8.7
        ),
        Movie(
            title: "Titanic",
            overview: "A timeless romance blossoms aboard the ill-fated RMS Titanic.",
            posterPath: nil,
            voteAverage: 5.9
        ),
        Movie(
            title: "Dune",
            overview: "Paul Atreides embarks on a journey across the desert planet Arrakis to fulfill his destiny.",
            posterPath: nil,
            voteAverage: 8.2
        )
    ]
    ///////////
    
    @State private var searchQuery = ""
    @State private var isShowingSearch: Bool = false
    @State private var isShowingAlert: Bool = false
    var filteredMovies: [Movie] {
        return searchQuery.isEmpty ? movieSamples : movieSamples.filter{$0.title.localizedCaseInsensitiveContains(searchQuery)}
    }
    ///////
    var body: some View {
        let _ = Self._printChanges()
        NavigationStack{
            List(){
                ForEach(filteredMovies){movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)){
                        MovieCardView(
                            movie: movie,
                            onDelete: {movie in deleteMovie(movie)},
                            onFavorite: {movie in toggleFavorite(movie)}
                        )
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("MiniFlix")
            .toolbar{
                Button{
                    isShowingSearch = true
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
        .sheet(isPresented: $isShowingSearch){
            SearchSheetView(searchQuery: $searchQuery)
        }
    }
    
    //////
    func deleteMovie(_ movie: Movie) {
        if let index = movieSamples.firstIndex(where: {$0.id == movie.id}){
            movieSamples.remove(at: index)
        }
    }

    func toggleFavorite(_ movie: Movie) {
        if let index = movieSamples.firstIndex(where: {$0.id == movie.id}){
            movieSamples[index].isFavorite.toggle()
        }
    }
    
    
}

struct SearchSheetView: View{
    @Environment(\.dismiss) var dismiss
    @Binding var searchQuery: String
    
    var body: some View{
        NavigationStack{
            Text("Tìm kiếm phim")
                .font(.headline)
                .padding(.top)
            
            TextField("Tên phim...", text: $searchQuery)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Button("Tìm"){
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }.padding()
    }
}
