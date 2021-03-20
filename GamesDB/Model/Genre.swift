//
//  Genre.swift
//  GamesDB
//
//  Created by admin on 10.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

struct Genre: Codable, Hashable {
    let id: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return rhs.id == lhs.id
    }
}

