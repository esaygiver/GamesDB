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
    @IBOutlet weak var activityIndicatorHeight: NSLayoutConstraint!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var noGameReturnView: UIView!
    
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
        
        setDelegations()
        gamesAtMainScreen(page: nextPage)
    }
    
    func setDelegations() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        activityIndicator.isHidden = true
    }
}

//MARK: - Network Request
extension SearchViewController {
    // It is default game request
    func gamesAtMainScreen(page: Int) {
        networkManager.fetchDefaultGames(page: page) { [weak self] results in
            guard let self = self else { return }
            self.setLoadingMoreState(to: false)
            if results.isEmpty {
                self.screenState = .empty
            } else {
                self.searchingGamesData.append(contentsOf: results)
                self.screenState = .loaded
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchGames(page: Int, query: String) {
        networkManager.fetchGamesWithQuery(page: page, query: query) { [weak self] results in
            guard let self = self else { return }
            self.setLoadingMoreState(to: false)
            if results.isEmpty {
                self.screenState = .empty
            } else {
                self.searchingGamesData.append(contentsOf: results)
                self.screenState = .loaded
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
        searchBar.endEditing(true)
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
            // filterview showing
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
        searchingGamesData[indexPath.row].isGameVisitedBefore = true
        
        let detailVC = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailVC.gameDataFromSearchVC = searchingGamesData[indexPath.row]
        detailVC.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? GameTableViewCell {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.8783541322, green: 0.8784807324, blue: 0.8783264756, alpha: 1)
        }
    }
    
    //MARK: - Pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == searchingGamesData.count - 1 {
            setLoadingMoreState(to: true)
            nextPage += 1
            fetchGames(page: nextPage, query: queryForPagination)
        }
    }
}

//MARK: - loading
extension SearchViewController {
    func setLoadingMoreState(to isLoading: Bool) {
        if isLoading {
            UIView.animate(withDuration: 0.7) {
                self.activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.activityIndicatorHeight.constant = 80
            }
            activityIndicator.startAnimating()
        } else {
            UIView.animate(withDuration: 0.7) {
                self.activityIndicator.transform = .identity
                self.activityIndicatorHeight.constant = 0
            }
            activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
        }
    }
}



