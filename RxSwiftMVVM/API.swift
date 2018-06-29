//
//  API.swift
//  RxSwiftMVVM
//
//  Created by Sha on 6/23/18.
//

import Moya

enum API {
    case posts
    case comments(postId: Int)
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .posts:
            return "/posts"
        case .comments(let postId):
            return "/posts/\(postId)/comments"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return [ "Accept": "application/json" ]
    }
}
