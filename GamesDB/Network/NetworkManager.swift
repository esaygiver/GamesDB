//
//  NetworkManager.swift
//  GamesDB
//
//  Created by admin on 10.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation
import Moya

class NetworkManager: Networkable {
    
    var provider = MoyaProvider<GameAPI>(plugins: [NetworkLoggerPlugin()])
    
    func fetchDefaultGames(page: Int, completion: @escaping ([Game]) -> ()) {
        provider.request(.defaultSearch(page: page)) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(GameData.self, from: response.data)
                    completion(results.games)
                } catch let error {
                    dump(error)
                }
            case let .failure(error):
                dump(error)
            }
        }
    }
    
    func fetchGamesWithQuery(page: Int, query: String, completion: @escaping ([Game]) -> ()) {
        provider.request(.gameSearch(page: page, query: query)) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(GameData.self, from: response.data)
                    completion(results.games)
                } catch let error {
                    dump(error)
                }
            case let .failure(error):
                dump(error)
            }
        }
    }
}
