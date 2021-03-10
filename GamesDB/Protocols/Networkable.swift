//
//  Networkable.swift
//  GamesDB
//
//  Created by admin on 10.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation
import Moya

protocol Networkable {
    
    var provider: MoyaProvider<GameAPI> { get }
    func fetchDefaultGames(page: Int, completion: @escaping ([Game]) -> ())
    func fetchGamesWithQuery(page: Int, query: String, completion: @escaping ([Game]) -> () )
}
