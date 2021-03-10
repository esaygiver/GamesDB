//
//  Keys.swift
//  GamesDB
//
//  Created by admin on 10.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

enum Keys: String, CaseIterable {
    case baseURL
    case APIKey
}

func getURL(on platform: Keys) -> String {
    switch platform {
    case .APIKey:
        return "59a7ebbbcb214c95b1a528c3adb20f58"
    case .baseURL:
        return "https://api.rawg.io/api/games"
    }
    
}
