//
//  MiniFlixApp.swift
//  MiniFlix
//
//  Created by Tuong Vi on 7/7/26.
//

import SwiftUI
import SwiftData

@main
struct MiniFlixApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: FavoriteMovieItem.self)
        }
    }
}
