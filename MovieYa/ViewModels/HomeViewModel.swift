//
//  MovieHomeViewModel.swift
//  MovieYa
//
//  Created by 이상준 on 2023/09/30.
//

import UIKit
import RxSwift

final class HomeViewModel {
    
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func fetchNowPlaying() -> Observable<[MovieViewModel]> {
        return  movieRepository.fetchNowPlaying().map { $0.map { MovieViewModel(movie: $0) } }
    }
    
    func fetchPopular() -> Observable<[MovieViewModel]> {
        return movieRepository.fetchPopularMovies().map { $0.map { MovieViewModel(movie: $0) } }
    }
    
    func fetchTopRated() -> Observable<[MovieViewModel]> {
        return movieRepository.fetchTopRated().map { $0.map { MovieViewModel(movie: $0) } }
    }
    
    func fetchUpcoming() -> Observable<[MovieViewModel]> {
        return movieRepository.fetchUpcoming().map { $0.map { MovieViewModel(movie: $0) } }
    }
}
