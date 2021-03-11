//
//  API.swift
//  GamesDB
//
//  Created by admin on 10.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation
import Moya

enum GameAPI {
    case defaultSearch(page: Int)
    case gameSearch(page: Int, query: String)
    case gameDetail(gameID: Int)
}

private let APIKey = getURL(on: Keys.APIKey)

extension GameAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: getURL(on: Keys.baseURL)) else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .defaultSearch(_), .gameSearch(_,_):
            return ""
        case .gameDetail(gameID: let gameID):
            return "/\(gameID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .defaultSearch(_), .gameSearch(_,_), .gameDetail(_):
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .defaultSearch(page: let page):
            return .requestParameters(parameters: ["api_key" : APIKey,
                                                   "page" : page], encoding: URLEncoding.queryString)
        case .gameSearch(page: let page, query: let query):
            return .requestParameters(parameters: ["api_key" : APIKey,
                                                   "page" : page,
                                                   "search" : query], encoding: URLEncoding.queryString)
        case .gameDetail(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
