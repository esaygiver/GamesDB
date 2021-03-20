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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteNavigationTitle: UINavigationItem!
    
    var favoriteGames = [FavoriteGames]()
    private let realm = try! Realm()
    
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
    
    // FIXME: remove this
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        updateData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.updateLayoutAfterChanges()
        })
    }
    
    func updateData() {
        favoriteGames = Array(realm.objects(FavoriteGames.self))
        realm.autorefresh = true
    }

    func updateLayoutAfterChanges() {
        self.tableView.reloadData()
        self.favoriteNavigationTitle.title = "Favorites(\(self.favoriteGames.count))"
    }
}

//MARK: - TableView Delegate & Datasource
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteGameCell", for: indexPath) as! FavoriteGameTableViewCell
        let selectedGameCell = favoriteGames[indexPath.row]
        cell.configureOutlets(on: selectedGameCell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //        let selectedGameID = favoriteGames[indexPath.row].gameID
        //        let detailVC = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        //        detailVC.gameID = selectedGameID
        //        detailVC.modalTransitionStyle = .flipHorizontal
        //        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        realm.beginWrite()
        realm.delete(favoriteGames[indexPath.row])
        self.favoriteGames.remove(at: indexPath.row)
        try! realm.commitWrite()
        updateLayoutAfterChanges()
    }
    
}



