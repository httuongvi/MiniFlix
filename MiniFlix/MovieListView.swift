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
                if let posterPath = movie.posterPath{
                    let urlPoster = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
                    AsyncImage(url: urlPoster){phase in
                        switch phase{
                        case .empty:
                            ProgressView()
                                .frame(width: 70, height: 100)
                                .foregroundColor(.gray.opacity(0.4))
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 100)
                                .clipped()
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 40))
                                .frame(width: 70, height: 100)
                                .background(.gray.opacity(0.3))
                        
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "film")
                        .font(.system(size: 40))
                        .frame(width: 70, height: 100)
                        .background(.gray.opacity(0.3))
                }
                
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
                    Text(String(format: "%.1f", movie.voteAverage))
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
    private let service = TMDBService()
    
    @State private var movieSamples: [Movie] = []
    
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
            .task {
                await loadPopularMovies()
            }
        }
        .sheet(isPresented: $isShowingSearch){
            SearchSheetView(
                searchQuery: $searchQuery,
                onSearch: { await onSearch()}
            )
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
    
    @MainActor
    private func loadPopularMovies() async {
        guard movieSamples.isEmpty else { return }
        do{
            let fetchedMovies = try await service.fetchPopular()
            self.movieSamples = fetchedMovies
        } catch{
            print("Đã xảy ra lỗi khi load danh sách phim phổ biến: \(error)")
        }
    }
    
    @MainActor
    private func onSearch() async {
        guard !searchQuery.isEmpty else {
            return
        }
        
        do{
            let searchRusults = try await service.searchMovies(query: searchQuery)
            self.movieSamples = searchRusults
        } catch {
            print("Lỗi tìm kiếm: \(error)")
        }
    }
    
    
}


////////////////
struct SearchSheetView: View{
    @Environment(\.dismiss) var dismiss
    @Binding var searchQuery: String
    var onSearch: () async -> Void
    
    var body: some View{
        NavigationStack{
            Text("Tìm kiếm phim")
                .font(.headline)
                .padding(.top)
            
            TextField("Tên phim...", text: $searchQuery)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Button("Tìm"){
                Task{
                    await onSearch()
                    dismiss()
                }
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }.padding()
    }
}


