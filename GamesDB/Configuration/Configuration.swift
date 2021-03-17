//
//  Configuration.swift
//  GamesDB
//
//  Created by admin on 17.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

enum Configuration: String {
    case debug
    case release
    
    static let current: Configuration = {
        guard let rawValue = Bundle.main.infoDictionary?["Configuration"] as? String else {
            fatalError("No Configuraiton Found")
        }
        
        guard let configuration = Configuration(rawValue: rawValue.lowercased()) else {
            fatalError("Invalid Configuration")
        }
        
        return configuration
    }()
    
    static var baseURL: String {
        switch current {
        case .debug, .release:
            return "https://api.rawg.io/api/games"
            
        }
    }
    
    static let APIKey: String = {
        switch Configuration.current {
        case .debug, .release:
            return "59a7ebbbcb214c95b1a528c3adb20f58"
        }
    }()
    
}


