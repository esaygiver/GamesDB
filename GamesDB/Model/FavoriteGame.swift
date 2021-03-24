//
//  FavoriteGames.swift
//  GamesDB
//
//  Created by admin on 13.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteGame: Object {
    @objc dynamic var gameTitle: String = ""
    @objc dynamic var gameBackdrop: String = ""
    @objc dynamic var gameMetacritic: Int = 1
    @objc dynamic var gameID: Int = 1
    
    var isFavoritedGame: Bool = false
    
    convenience init(with game: Game) {
        self.init()
        self.gameTitle = game.name!
        self.gameBackdrop = game.backgroundImage!
        self.gameMetacritic = game.metacritic ?? 90
        self.gameID = game.id
    }
}
