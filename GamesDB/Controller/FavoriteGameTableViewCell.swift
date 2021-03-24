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

    func configureOutlets(on model: FavoriteGame) {
        gameTitle.text = model.gameTitle
        gameImage.fetchImage(from: model.gameBackdrop)
        gameMetacritic.text = model.gameMetacritic.description
    }
}
