//
//  FavoriteViewController.swift
//  GamesDB
//
//  Created by admin on 10.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit
import RealmSwift

final class FavoriteViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var favoriteNavigationTitle: UINavigationItem!
    
    var favoriteGamesAtFavoriteVC = [FavoriteGame]()
    private let realm = try! Realm()
    
    var screenState: FavoriteListState? {
        didSet {
            if screenState == .loaded {
                filterView.isHidden = true
                tableView.isHidden = false
            } else {
                tableView.isHidden = true
                filterView.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        updateLayoutAfterChanges()
        setDelegations()
        InternalEvent.addObservers(observers: observers, controller: self)
        
    }
    
    // Internal event observers
    let observers: [(event: InternalEvent, selector: Selector)] = [
        (event: .gameFavorited, selector: #selector(FavoriteViewController.refreshScreen)),
    ]
    
    @objc func refreshScreen() {
        updateData()
        updateLayoutAfterChanges()
    }
    
    func setDelegations() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    
    func updateData() {
        favoriteGamesAtFavoriteVC = Array(realm.objects(FavoriteGame.self))
        realm.autorefresh = true
    }
    
    func updateLayoutAfterChanges() {
        self.tableView.reloadData()
        self.favoriteNavigationTitle.title = "Favorites(\(self.favoriteGamesAtFavoriteVC.count))"
        checkingFavoriteGamesState()
    }
    
    func checkingFavoriteGamesState() {
        if self.favoriteGamesAtFavoriteVC.count == 0 {
            screenState = .empty
            self.favoriteNavigationTitle.title = "Favorites"
        } else {
            screenState = .loaded
        }
    }
}

//MARK: - TableView Delegate & Datasource
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteGamesAtFavoriteVC.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteGameCell", for: indexPath) as! FavoriteGameTableViewCell
        let selectedGameCell = favoriteGamesAtFavoriteVC[indexPath.row]
        cell.configureOutlets(on: selectedGameCell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        realm.beginWrite()
        realm.delete(favoriteGamesAtFavoriteVC[indexPath.row])
        self.favoriteGamesAtFavoriteVC.remove(at: indexPath.row)
        try! realm.commitWrite()
        updateLayoutAfterChanges()
    }
    
}



