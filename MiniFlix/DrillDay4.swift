//
//  DrillDay4.swift
//  MiniFlix
//
//  Created by Tuong Vi on 13/7/26.
//

import SwiftUI

//Lỗi force-unwrap
//struct DrillDay4: View {
//    var body: some View {
//        Button("Xem chi tiết phim") {
//            let linkTrailer: String? = nil
//            let urlBatBuoc = linkTrailer!
//            print("Đang mở: \(urlBatBuoc)")
//        }
//    }
//}

// fix with guard let
struct DrillDay4FixUnwrap: View {
    var body: some View {
        Button("Xem chi tiết phim") {
            let linkTrailer: String? = "ekdk"
            
            guard let urlAnToan = linkTrailer else {
                print("Lỗi: Không tìm thấy link trailer")
                return
            }
            print("Đang mở: \(urlAnToan)")
        }
    }
}

//var movies : [Movie] = [
//    Movie(title: "movie one", overview: "overview one", voteAverage: 5.5),
//    Movie(title: "movie two", overview: "overview two", voteAverage: 6.5),
//    Movie(title: "movie three", overview: "overview three", voteAverage: 7.0),
//    Movie(title: "movie four", overview: "overview four", voteAverage: 6.5),
//    Movie(title: "movie five", overview: "overview five", voteAverage: 5.5),
//    Movie(title: "movie six", overview: "overview six", voteAverage: 8.5),
//    Movie(title: "movie seven", overview: "overview seven", voteAverage: 7.0),
//    Movie(title: "movie eight", overview: "overview eight", voteAverage: 6.5)
//]

//struct DrillDay4ConditionalBreakpoint: View {
//    var body: some View {
//        Button("Xem tên phim") {
//            for movie in movies {
//                print(movie.title)
//            }
//        }
//    }
//}






