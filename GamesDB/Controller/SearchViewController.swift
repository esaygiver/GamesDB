//
//  ViewController.swift
//  GamesDB
//
//  Created by admin on 10.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var gameData = [Game]()
    lazy var networkManager = NetworkManager()
    lazy var nextPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDelegations()
        gamesAtMainScreen(page: nextPage)
    }
    
    func getDelegations() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - Network Request
extension SearchViewController {
    
    func gamesAtMainScreen(page: Int) {
        networkManager.fetchDefaultGames(page: page) { [weak self] results in
            guard let self = self else { return }
            if results.isEmpty {
                self.tableView.isHidden = true
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            } else {
                self.gameData.append(contentsOf: results)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                }
            }
        }
    }
    
    func fetchGames(query: String) {
        networkManager.fetchGamesWithQuery(query: query) { [weak self] results in
            guard let self = self else { return }
            if results.isEmpty {
                self.tableView.isHidden = true
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.startAnimating()
                self.gameData = results
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                })
            }
        }
    }
}

//MARK: - TableView Delegate & Datasource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        let selectedGameCell = gameData[indexPath.row]
        cell.configureOutlets(on: selectedGameCell)
        return cell
    }
    //MARK: - pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == gameData.count - 1 {
            // activityindicator not hidden and starts
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            nextPage += 1
            gamesAtMainScreen(page: nextPage)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO Segue or instantiate storyboard
    }

}

