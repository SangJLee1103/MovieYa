//
//  Router.swift
//  MovieYa
//
//  Created by 이상준 on 2023/09/23.
//

import Alamofire

enum MovieRouter: URLRequestConvertible {
    case fetchNowPlaying
    case fetchPopularList
    case fetchTopRated
    case fetchUpcoming
    case fetchSearchMovie(text: String)
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchNowPlaying, .fetchPopularList, .fetchTopRated, .fetchUpcoming: return .get
        case .fetchSearchMovie: return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchNowPlaying: return "/movie/now_playing"
        case .fetchPopularList: return "/movie/popular"
        case .fetchTopRated: return "/movie/top_rated"
        case .fetchUpcoming: return "/movie/upcoming"
        case .fetchSearchMovie: return "/movie/search"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchNowPlaying, .fetchPopularList, .fetchTopRated, .fetchUpcoming:
            return [
                "language": "ko-KR",
            ]
        case .fetchSearchMovie(let text):
            return [
                "query": text
            ]
        }
    }
    
    var headers: [String: String]? {
        if let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String {
            let headers: [String: String] = [
                "accept": "application/json",
                "Authorization": "Bearer \(key)"
            ]
            return headers
        } else {
            fatalError("API Key not found")
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        do {
            request = try URLEncoding.default.encode(request, with: parameters)
        } catch {
            throw error // 인코딩 오류 발생 시 예외 처리
        }
        
        return request
    }
}
