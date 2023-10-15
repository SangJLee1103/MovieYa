//
//  MovieRepositoryImpl.swift
//  MovieYa
//
//  Created by 이상준 on 2023/09/23.
//

import Alamofire
import RxSwift

class MovieRepositoryImpl: MovieRepository {
    
    func fetchNowPlaying() -> Observable<[Movie]> {
        return Observable.create { (observer) -> Disposable in
            AF.request(MovieRouter.fetchNowPlaying).responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let data):
                    observer.onNext(data.results)
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func fetchPopularMovies() -> Observable<[Movie]> {
        return Observable.create { (observer) -> Disposable in
            AF.request(MovieRouter.fetchPopularList).responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let data):
                    observer.onNext(data.results)
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func fetchTopRated() -> Observable<[Movie]> {
        return Observable.create { (observer) -> Disposable in
            AF.request(MovieRouter.fetchTopRated).responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let data):
                    observer.onNext(data.results)
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func fetchUpcoming() -> Observable<[Movie]> {
        return Observable.create { (observer) -> Disposable in
            AF.request(MovieRouter.fetchUpcoming).responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let data):
                    observer.onNext(data.results)
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
