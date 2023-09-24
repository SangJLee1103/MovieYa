//
//  Router.swift
//  MovieYa
//
//  Created by 이상준 on 2023/09/23.
//

import Alamofire

enum MovieRouter: URLRequestConvertible {
    case fetchPopularList
    case fetchSearchMovie(text: String)
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .fetchPopularList: return .get
        case .fetchSearchMovie: return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchPopularList: return "/popular/movie"
        case .fetchSearchMovie: return "/search/movie"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchSearchMovie(var text):
            return [
                "query": text
            ]
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
