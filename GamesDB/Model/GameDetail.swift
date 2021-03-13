//
//  GameDetail.swift
//  GamesDB
//
//  Created by admin on 11.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

struct GameDetail: Codable {
    let name: String
    let description: String
    let backgroundImage: String
    let redditURL: String?
    let websiteURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, description, backgroundImage = "background_image", redditURL = "reddit_url", websiteURL = "website"
    }
}


