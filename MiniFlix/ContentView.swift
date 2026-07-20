//
//  ContentView.swift
//  MiniFlix
//
//  Created by Tuong Vi on 7/7/26.
//

import SwiftUI

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
    @State private var selectedTab: Int = 0
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
        }
    }
}



#Preview {
    ContentView()
}
