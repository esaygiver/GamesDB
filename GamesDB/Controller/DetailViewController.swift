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
import RealmSwift

final class DetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var sorryMessage: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var visitRedditButton: UIButton!
    @IBOutlet weak var visitWebsiteButton: UIButton!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var gameDescrition: UILabel! {
        didSet {
            gameDescrition.numberOfLines = 4
        }
    }
    
    private let realm = try! Realm()
    lazy var networkManager = NetworkManager()
    var gameDetail: GameDetail!
    var gameDataFromSearchVC: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        fetchGameDetails(gameID: gameDataFromSearchVC.id)
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
            gameDescrition.numberOfLines = 0
        } else {
            gameDescrition.numberOfLines = 4
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        let favoriteGame = FavoriteGame()
        if favoriteButton.title == "Favorite" {
            favoriteButton.title = "Favorited"
            // when we tapped fav button realm begins write game data
            realm.beginWrite()
            favoriteGame.gameID = gameDataFromSearchVC.id
            favoriteGame.gameTitle = gameDataFromSearchVC.name!
            favoriteGame.gameBackdrop = gameDataFromSearchVC.backgroundImage!
      //      favoriteGame.gameGenreInstances = GameDataFromSearchVC.genres
            favoriteGame.gameMetacritic = gameDataFromSearchVC.metacritic ?? 90
            realm.add(favoriteGame)
            realm.refresh()
            try! realm.commitWrite()
        } else {
            favoriteButton.title = "Favorite"
        }
        
        InternalEvent.gameFavorited.send(attachment: nil)
    }
    
    @IBAction func visitRedditButtonTapped(_ sender: UIButton) {
        if gameDetail.redditURL != "" {
            if let url = gameDetail.redditURL {
                let vc = SFSafariViewController(url: URL(string: url)!)
                vc.modalPresentationStyle = .popover
                // modalPresentationStyle needs to be changed before using iPad. -> .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
        } else {
            sorryMessage.text = "😢 Sorry, game you searched does not have reddit page."
            sorryMessage.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.sorryMessage.isHidden = true
            }
        }
    }
    
    @IBAction func visitWebbsiteButtonTapped(_ sender: UIButton) {
        if gameDetail.websiteURL != "" {
            if let url = gameDetail.websiteURL {
                let vc = SFSafariViewController(url: URL(string: url)!)
                vc.modalPresentationStyle = .popover
                // modalPresentationStyle needs to be changed before using iPad. -> .fullScreen
                vc.modalTransitionStyle = .flipHorizontal
                self.present(vc, animated: true)
            }
        } else {
            sorryMessage.text = "😢 Sorry, game you searched does not have website."
            sorryMessage.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.sorryMessage.isHidden = true
            }
        }
        
    }
    
}

//MARK: - Network Request
extension DetailViewController {
    func fetchGameDetails(gameID: Int) {
        networkManager.fetchGamesDetails(gameID: gameID) { [weak self] result in
            guard let self = self else { return }
            self.gameDetail = result
            DispatchQueue.main.async {
                self.updateOutlets()
            }
        }
    }
}

