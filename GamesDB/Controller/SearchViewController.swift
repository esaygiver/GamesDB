//
//  ViewController.swift
//  GamesDB
//
//  Created by admin on 10.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit

enum SearchListState: String {
    case loaded
    case searching
    case empty
}

final class SearchViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var noGameReturnView: UIView!
    
    lazy var defaultGamesData = [Game]()
    lazy var searchingGamesData = [Game]()
    lazy var networkManager = NetworkManager()
    lazy var nextPage: Int = 1
    // for default case
    lazy var queryForPagination = ""
    // for default case
    
    var screenState: SearchListState? {
        didSet {
            if screenState == .searching {
                filterView.isHidden = false
                tableView.isHidden = true
                noGameReturnView.isHidden = true
            } else if screenState == .loaded {
                filterView.isHidden = true
                tableView.isHidden = false
                noGameReturnView.isHidden = true
            } else {
                filterView.isHidden = true
                tableView.isHidden = true
                noGameReturnView.isHidden = false
            }
        }
    }
    
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
        searchBar.enablesReturnKeyAutomatically = false
    }
}

//MARK: - Network Request
extension SearchViewController {
    
    func gamesAtMainScreen(page: Int) {
        networkManager.fetchDefaultGames(page: page) { [weak self] results in
            guard let self = self else { return }
            if results.isEmpty {
                self.screenState = .empty
            } else {
                self.defaultGamesData.append(contentsOf: results)
                self.searchingGamesData.append(contentsOf: results)
                self.screenState = .loaded
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
                self.screenState = .empty
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            } else {
                self.searchingGamesData.append(contentsOf: results)
                self.screenState = .loaded
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                }
            }
        }
    }
}

//MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        nextPage = 1
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        nextPage = 1
//        searchingGamesData = []
//        gamesAtMainScreen(page: nextPage)
        searchBar.endEditing(true)
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else { return }
        queryForPagination = query
        nextPage = 1
        // nextpage reset because it might be changed at main screen, we want to add 1 when you pagination at search screen
        if query.isEmpty {
            // tableview shows the default games
            searchingGamesData = []
            gamesAtMainScreen(page: nextPage)
        } else if query != "" && query.count < 3 {
            searchingGamesData = []
            // searchingGamesData reset as there were games comin from default request
            screenState = .searching
            // filterview shows
        } else if query.count >= 3 {
            fetchGames(page: nextPage, query: queryForPagination)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedGameID = searchingGamesData[indexPath.row].id
        let detailVC = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailVC.gameID = selectedGameID
        detailVC.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(detailVC, animated: true)
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
}


