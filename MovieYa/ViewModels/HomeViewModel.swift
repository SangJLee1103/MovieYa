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
    
    func fetchMovieList() -> Observable<[MovieViewModel]> {
        let nowPlayingObservable = movieRepository.fetchNowPlaying()
            .map { $0.map { MovieViewModel(movie: $0) } }
        
        let popularObservable = movieRepository.fetchPopularMovies()
            .map { $0.map { MovieViewModel(movie: $0) } }
        
        let topRatedObservable = movieRepository.fetchTopRated()
            .map { $0.map { MovieViewModel(movie: $0) } }
        
        let upcomingObservable = movieRepository.fetchUpcoming()
            .map { $0.map { MovieViewModel(movie: $0) } }
        
        return Observable.combineLatest(
              nowPlayingObservable,
              popularObservable,
              topRatedObservable,
              upcomingObservable
        )
    }
}
