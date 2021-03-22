//
//  Game.swift
//  GamesDB
//
//  Created by admin on 10.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

struct Game: Codable, Hashable {
    let name: String?
    let id: Int
    let backgroundImage: String?
    let metacritic: Int?
    let genres: [Genre]
    
    var isGameVisitedBefore: Bool = false
    var isGameFavoritedOrNot: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case name, id, metacritic, genres, backgroundImage = "background_image"
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return rhs.id == lhs.id
    }
}
