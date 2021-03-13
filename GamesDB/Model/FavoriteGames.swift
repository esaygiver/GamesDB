//
//  FavoriteGames.swift
//  GamesDB
//
//  Created by admin on 13.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteGames: Object {
    @objc dynamic var gameTitle: String = ""
//    @objc dynamic var gameGender: [Genre] = []
    @objc dynamic var gameBackdrop: String = ""
//    dynamic var gameMetacritic: Int?
    @objc dynamic var gameID: Int = 1
    
}

