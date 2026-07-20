//
//  MovieListView.swift
//  MiniFlix
//
//  Created by Tuong Vi on 14/7/26.
//

import SwiftUI
struct MovieCardView: View{
    let movie: Movie
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
    }
}

struct MovieListView: View {
    private let service = TMDBService()
    
    @State var viewModel = MovieListViewModel()
    
    @State private var searchQuery = ""
    @State private var isShowingSearch: Bool = false
    @State private var isShowingAlert: Bool = false
    //    var filteredMovies: [Movie] {
    //        return searchQuery.isEmpty ? movieSamples : movieSamples.filter{$0.title.localizedCaseInsensitiveContains(searchQuery)}
    //    }
    ///////
    var body: some View {
        let _ = Self._printChanges()
        NavigationStack{
            Group{
                switch viewModel.state{
                case .idle:
                    Color.clear
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .loaded(let movies):
                    List(){
                        ForEach(movies){movie in
                            NavigationLink(destination: MovieDetailView(movie: FavoriteMovieItem(
                                id: movie.id,
                                title: movie.title,
                                overview: movie.overview,
                                posterPath: movie.posterPath,
                                voteAverage: movie.voteAverage
                            ))){
                                MovieCardView(
                                    movie: movie
                                )
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .refreshable {
                        await viewModel.refresh()
                    }
                case .empty:
                    VStack(spacing: 12) {
                        Image(systemName: "film.stack")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Không có bộ phim nào hiển thị.")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .error(let message):
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Đã xảy ra lỗi.\(message)")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Button("Thử lại"){
                            Task{
                                await viewModel.refresh()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
            }
            .navigationTitle("MiniFlix")
            .toolbar{
                Button{
                    isShowingSearch = true
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
            .task {
                await viewModel.loadPopularMovies()
            }
        }
        .sheet(isPresented: $isShowingSearch){
            SearchSheetView(
                viewModel: viewModel
            )
        }
    }
    
    //////
    
    
    
    ////////////////
    struct SearchSheetView: View{
        @Environment(\.dismiss) var dismiss
        
        var viewModel: MovieListViewModel
        
        var body: some View{
            @Bindable var bviewModel = viewModel
            NavigationStack{
                Text("Tìm kiếm phim")
                    .font(.headline)
                    .padding(.top)
                
                TextField("Tên phim...", text: $bviewModel.searchQuery)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Button("Tìm"){
                    Task{
                        await viewModel.onSearch()
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                Spacer()
            }.padding()
        }
    }
}


#Preview() {
    MovieListView()
}


