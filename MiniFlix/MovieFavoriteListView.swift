//
//  MovieFavoriteListView.swift
//  MiniFlix
//
//  Created by Tuong Vi on 19/7/26.
//

import Foundation
import SwiftData
import SwiftUI


struct MovieFavoriteListView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Query(sort: \FavoriteMovieItem.timestamp, order: .reverse)
    private var favoriteMovies: [FavoriteMovieItem]
    
    @State private var viewModel: MovieFavoriteListViewModel = MovieFavoriteListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if favoriteMovies.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "heart.slash.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Chưa có bộ phim yêu thích nào.")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                } else {
                    Text("Đã lưu \(favoriteMovies.count) phim yêu thích")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    
                    List {
                        ForEach(favoriteMovies) { item in
                            NavigationLink(destination: MovieDetailView(movie: item)) {
                                MovieCardView(
                                    movie: Movie(
                                        id: item.id,
                                        title: item.title,
                                        overview: item.overview,
                                        posterPath: item.posterPath,
                                        voteAverage: item.voteAverage
                                    )
                                )
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    viewModel.deleteMovie(
                                        item,
                                        modelContext: modelContext
                                    )
                                } label: {
                                    Label("Xoá", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Phim yêu thích")
        }
    }
}

#Preview {
    MovieFavoriteListView()
}
