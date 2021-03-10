//
//  GameTableViewCell.swift
//  GamesDB
//
//  Created by admin on 10.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit

final class GameTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameMetacritic: UILabel!
    @IBOutlet weak var gameGenres: UILabel!
    
    func configureOutlets(on model: Game) {
        gameTitle.text = model.name
        gameImage.fetchImage(from: model.backgroundImage ?? "https://media.rawg.io/media/games/295/295eb868c241e6ad32ac033b8e6a2ede.jpg")
        gameMetacritic.text = model.metacritic?.description ?? "-"
        if model.genres.isEmpty {
            gameGenres.text = "-"
        } else if model.genres.first?.name == model.genres.last?.name {
            gameGenres.text = model.genres.first!.name
        } else {
            gameGenres.text = "\(model.genres.first!.name), \((model.genres.last!.name))"
        }
        
    }


}
