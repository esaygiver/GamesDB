//
//  GameData.swift
//  GamesDB
//
//  Created by admin on 10.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

struct GameData: Codable {
    let games: [Game]
    
    private enum CodingKeys: String, CodingKey {
        case games = "results"
    }
}

