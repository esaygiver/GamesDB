//
//  DetailViewController.swift
//  GamesDB
//
//  Created by admin on 11.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit
import Moya
import SafariServices

final class DetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var visitRedditButton: UIButton!
    @IBOutlet weak var visitWebsiteButton: UIButton!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
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
    
    @IBAction func readMeButtonTapped(_ sender: UIButton) {

        if gameDescrition.numberOfLines == 4 {
            gameDescrition.numberOfLines = 18
        } else {
            gameDescrition.numberOfLines = 4
        }
    }
    
    @IBAction func favoriteButtonTapped(_ ssender: UIButton) {
        if favoriteButton.title == "Favorite" {
            favoriteButton.title = "Favorited"
        } else {
            favoriteButton.title = "Favorite"
        }
    }
    
    @IBAction func visitRedditButtonTapped(_ sender: UIButton) {
            let url = gameDetail.redditURL
            let vc = SFSafariViewController(url: (URL(string: url) ?? URL(string: "https://www.reddit.com/search/)"))!)
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
    }
    
    @IBAction func visitWebbsiteButtonTapped(_ sender: UIButton) {
        let url = gameDetail.websiteURL
        let vc = SFSafariViewController(url: (URL(string: url) ?? URL(string: "https://www.google.com"))!)
        // TODO - Change google
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
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

