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
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("backgroundTime") private var backgroundTime: Double = 0
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: FavoriteMovieItem.self)
        }
        .onChange(of: scenePhase){
            switch scenePhase {
            case .background:
                print("vào background")
                backgroundTime = Date().timeIntervalSince1970
            case .inactive:
                print("đang inactive")
            case .active:
                print("đang active")
            @unknown default:
            break
            }
        }
    }
}
