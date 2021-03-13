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
        if favoriteButton.title == "Favourite" {
            favoriteButton.title = "Favourited"
        } else {
            favoriteButton.title = "Favourite"
        }
    }
    
    @IBAction func visitRedditButtonTapped(_ sender: UIButton) {
        if gameDetail.redditURL != "" {
            if let url = gameDetail.redditURL {
                let vc = SFSafariViewController(url: URL(string: url)!)
                vc.modalPresentationStyle = .popover
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
            print(self.gameDetail.name, self.gameDetail.description)
            DispatchQueue.main.async {
                self.updateOutlets()
            }
        }
    }
}

