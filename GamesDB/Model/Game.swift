//
//  Game.swift
//  GamesDB
//
//  Created by admin on 10.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

struct Game: Codable {
    let name: String
    let id: Int
    let backgroundImage: String
    let metacritic: Int
    let genres: [Genre]
    
    private enum CodingKeys: String, CodingKey {
        case name, id, metacritic, genres, backgroundImage = "background_image"
    }
}
