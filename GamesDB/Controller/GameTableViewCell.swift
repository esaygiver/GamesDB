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
    @IBOutlet weak var contentImage: UIView!
    
    var game: Game?

    override func prepareForReuse() {
        super.prepareForReuse()

        self.contentView.backgroundColor = game?.isMovieVisitedBefore ?? false ? #colorLiteral(red: 0.8783541322, green: 0.8784807324, blue: 0.8783264756, alpha: 1) : UIColor.white
    }
    
    func configureOutlets(on model: Game) {
        self.game = model
        gameTitle.text = model.name ?? "-"
        gameImage.fetchImage(from: model.backgroundImage ?? "https://media.rawg.io/media/games/295/295eb868c241e6ad32ac033b8e6a2ede.jpg")
        // TODO - There will be white screen URL besides this game image url as a default
        gameMetacritic.text = model.metacritic?.description ?? "-"
        self.contentView.backgroundColor = game?.isMovieVisitedBefore ?? false ? #colorLiteral(red: 0.8783541322, green: 0.8784807324, blue: 0.8783264756, alpha: 1) : UIColor.white
        
        if model.genres.isEmpty {
            gameGenres.text = "-"
        } else if model.genres.last != nil &&
                  model.genres.first?.name == model.genres.last?.name {
            gameGenres.text = model.genres.first!.name
        } else {
            gameGenres.text = "\(model.genres.first!.name), \((model.genres.last!.name))"
        }
       
//        if model.genres.isEmpty {
//            gameGenres.text = "-"
//        } else {
//            let uniqueGenres: [String] = Array(Set(model.genres)).prefix(2).map({ genre -> String in
//                return genre.name
//            })
//            gameGenres.text = uniqueGenres.joined(separator: ", ")
//        }
    }


}
