import Foundation

struct Movie: Identifiable, Codable {
    let id = UUID()
    var title: String
    var overview: String
    var posterPath: String?
    var voteAverage: Double
}



//bai 1
var movies : [Movie] = [
    Movie(title: "movie one", overview: "overview one", voteAverage: 5.5),
    Movie(title: "movie two", overview: "overview two", voteAverage: 8.5),
    Movie(title: "movie three", overview: "overview three", voteAverage: 7.0),
    Movie(title: "movie four", overview: "overview four", voteAverage: 6.5),
    Movie(title: "movie five", overview: "overview five", voteAverage: 5.5),
    Movie(title: "movie six", overview: "overview six", voteAverage: 8.5),
    Movie(title: "movie seven", overview: "overview seven", voteAverage: 7.0),
    Movie(title: "movie eight", overview: "overview eight", voteAverage: 6.5)
]

var moviesFilter = movies.filter{$0.voteAverage > 7}
var moviesMap = movies.map{$0.title}
var moviesSorted = movies.sorted(by: {$0.voteAverage > $1.voteAverage})

//bai 2
enum LoadState {
    case idle
    case loading
    case loaded([Movie])
    case failed(String)
}

func nhanState(_ state: LoadState){
    switch state {
    case .idle:
        print("Màn hình trống")
    case .loading:
        print("Đang tải ...")
    case .loaded(let movies):
        print("Màn hình hiển thị \(movies.count) phim")
    case .failed(let message):
        print("Có lỗi xảy ra: \(message)")
        
    }
}

let successState = LoadState.loaded(movies)
nhanState(successState)

let failState = LoadState.failed("Lỗi internet")
nhanState(failState)

let idleState = LoadState.idle
nhanState(idleState)
