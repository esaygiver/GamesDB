//
//  ViewController.swift
//  GamesDB
//
//  Created by admin on 10.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit

enum screenState: String {
    case loaded
    case searching
    case empty
}

final class SearchViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var defaultGamesData = [Game]()
    lazy var searchingGamesData = [Game]()
    lazy var networkManager = NetworkManager()
    lazy var nextPage: Int = 1
    // for default case
    lazy var queryForPagination = ""
    // for default case
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDelegations()
        gamesAtMainScreen(page: nextPage)
    }
    
    func getDelegations() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
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
                self.defaultGamesData.append(contentsOf: results)
                self.searchingGamesData.append(contentsOf: results)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                }
            }
        }
    }
    
    func fetchGames(page: Int, query: String) {
        networkManager.fetchGamesWithQuery(page: page, query: query) { [weak self] results in
            guard let self = self else { return }
            if results.isEmpty {
               // self.tableView.isHidden = true
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            } else {
                self.searchingGamesData.append(contentsOf: results)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                })
            }
        }
    }
}

//MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchingGamesData = defaultGamesData
        nextPage = 1
        searchBar.endEditing(true)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else { return }
        queryForPagination = query
        if !query.isEmpty && query.count >= 3 {
            searchingGamesData = []
            // searchingGamesData reset as there were games comin from default request
            nextPage = 1
            // nextpage reset because it might be changed at main screen, we want to add 1 when you pagination at search screen
            fetchGames(page: nextPage, query: queryForPagination)
        } else {
             self.searchingGamesData = defaultGamesData
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        return searchingGamesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        let selectedGameCell = searchingGamesData[indexPath.row]
        cell.configureOutlets(on: selectedGameCell)
        return cell
    }
    
    //MARK: - pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == searchingGamesData.count - 1 {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            nextPage += 1
            fetchGames(page: nextPage, query: queryForPagination)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO Segue or instantiate storyboard
    }
}


