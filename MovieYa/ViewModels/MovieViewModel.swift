//
//  MovieViewModel.swift
//  MovieYa
//
//  Created by 이상준 on 2023/09/30.
//

import Foundation

struct MovieViewModel {
    private let movie: Movie
    
    var adult: Bool {
        return movie.adult
    }
    
    var backdropPath: String? {
        return "https://image.tmdb.org/t/p/w500\(movie.backdropPath)"
    }
    
    var id: Int {
        return movie.id
    }
    
    var originalTitle: String {
        return movie.originalTitle
    }
    
    var overview: String {
        return movie.overview
    }
    
    var posterPath: String? {
        return "https://image.tmdb.org/t/p/w500\(movie.posterPath)"
    }
    
    var releaseDate: String {
        return movie.releaseDate
    }
    
    var title: String {
        return movie.title
    }
    
    var voteAverage: Double {
        return movie.voteAverage
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
}
