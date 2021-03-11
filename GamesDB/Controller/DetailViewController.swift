//
//  DetailViewController.swift
//  GamesDB
//
//  Created by admin on 11.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit
import Moya

final class DetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var visitRedditButton: UIButton!
    @IBOutlet weak var visitWebsiteButton: UIButton!
    @IBOutlet weak var gameDescrition: UILabel! {
        didSet {
            gameDescrition.numberOfLines = 4
        }
    }

    lazy var networkManager = NetworkManager()
    var gameDetail: GameDetail!
    lazy var gameID: Int = 1
    // for default game selection, it will change by indexPath.row
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        fetchGameDetails(gameID: gameID)
        
    }
    func updateOutlets() {
        self.gameImageView.fetchImage(from: gameDetail.backgroundImage)
        self.gameTitle.text = gameDetail.name
        self.gameDescrition.text = gameDetail.description
    }
    
    func setupButtons() {
        readMoreButton.getCurvyButton(readMoreButton)
        visitRedditButton.getCurvyButton(visitRedditButton)
        visitWebsiteButton.getCurvyButton(visitWebsiteButton)
    }
}

//MARK: - Network Request
extension DetailViewController {
    
    func fetchGameDetails(gameID: Int) {
        networkManager.fetchGamesDetails(gameID: gameID) { [weak self] result in
            guard let self = self else { return }
            self.gameDetail = result
            print(self.gameDetail.name, self.gameDetail.description)
            DispatchQueue.main.async {
                self.updateOutlets()
            }
        }
    }
}

