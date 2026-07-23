//
//  ContentView.swift
//  MiniFlix
//
//  Created by Tuong Vi on 7/7/26.
//

import SwiftUI
import _SwiftData_SwiftUI

struct ContentView: View {
    ///////////////////////////
    @State private var totalVotes: Int = 0
    
    
    
    
    
    
    var body: some View {
        let _ = Self._printChanges()
        
        MaintabView()
        
    }
    ////////////////
    ////////////////
    
    
}



///////////////////////
struct MaintabView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedTab: Int = 0
    @AppStorage("lastSelectedTab") private var lastSelectedTab: Int = 0
    @AppStorage("backgroundTime") private var backgroundTime: Double = 0
    @State private var notificationManager = NotificationManager.shared
    @Query private var favoriteMovies: [FavoriteMovieItem]
    
    var body: some View {
        let _ = Self._printChanges()
        TabView(selection: $selectedTab) {
            MovieListView()
                .tabItem {
                    Label("Phim", systemImage: "play.house.fill")
                }
                .tag(0)
            
            MovieFavoriteListView()
                .tabItem{
                    Label("Yêu thích", systemImage: "heart.fill")
                }
                .tag(1)
        }.onChange(of: scenePhase){oldValue, newValue in
            switch newValue{
            case .background:
                lastSelectedTab = selectedTab
            case .active:
                let currentTime = Date().timeIntervalSince1970
                if backgroundTime > 0 && currentTime - backgroundTime > 60{
                    print("Quá 1 phút")
                    selectedTab = 0
                } else {
                    selectedTab = lastSelectedTab
                }
            default:
                break
            }
        }
        .sheet(item: Binding(
            get: {
                if let id = notificationManager.selectedMovieId {
                    let movie = favoriteMovies.first(where: { $0.id == id })!
                    return movie
                }
                return nil
            },
            set: { _ in
                notificationManager.selectedMovieId = nil
            }
        )) { movieItem in
            NavigationStack {
                MovieDetailView(movie: movieItem)
            }
        }
    }
}



#Preview {
    ContentView()
}
