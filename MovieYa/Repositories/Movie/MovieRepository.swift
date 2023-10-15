//
//  MovieRepository.swift
//  MovieYa
//
//  Created by 이상준 on 2023/09/23.
//

import Foundation
import RxSwift

protocol MovieRepository {
    func fetchNowPlaying() -> Observable<[Movie]>
    func fetchPopularMovies() -> Observable<[Movie]>
    func fetchTopRated() -> Observable<[Movie]>
    func fetchUpcoming() -> Observable<[Movie]>
}
