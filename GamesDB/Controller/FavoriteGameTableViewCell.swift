//
//  FavoriteGameTableViewCell.swift
//  GamesDB
//
//  Created by admin on 13.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit

final class FavoriteGameTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameMetacritic: UILabel!
    @IBOutlet weak var gameGenres: UILabel!
    
    func configureOutlets(on model: FavoriteGame) {
        gameTitle.text = model.gameTitle
        gameImage.fetchImage(from: model.gameBackdrop)
        // TODO - There will be white screen URL besides this game image url
        gameMetacritic.text = model.gameMetacritic.description ?? "-"
        
//        if model.gameGender.isEmpty {
//            gameGenres.text = "-"
//        } else if model.gameGender.last != nil &&
//                  model.gameGender.first?.name == model.gameGender.last?.name {
//            gameGenres.text = model.gameGender.first!.name
//        } else {
//            gameGenres.text = "\(model.gameGender.first!.name), \((model.gameGender.last!.name))"
//        }
        
    }
}
