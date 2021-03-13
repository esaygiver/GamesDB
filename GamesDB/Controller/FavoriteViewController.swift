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
    //        willSet {
    //            if favoriteGames.count == 0 {
    //                tableView.isHidden = true
    //                filterView.isHidden = false
    //            } else {
    //                tableView.isHidden = false
    //                filterView.isHidden = true
    //            }
    //        }
    //    }
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteNavigationTitle: UINavigationItem! {
        didSet {
            DispatchQueue.main.async {
                self.favoriteNavigationTitle.title = "Favorites(\(self.favoriteGames.count))"
            }
        }
    }
    var favoriteGames = [FavoriteGames]()
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteGames = Array(realm.objects(FavoriteGames.self))
        getDelegations()
        activityIndicator.isHidden = true
    }
    
    func getDelegations() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        favoriteGames = Array(realm.objects(FavoriteGames.self))
        realm.autorefresh = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
        })
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
        DispatchQueue.main.async {
            self.favoriteGames.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        try! realm.commitWrite()
    }
    
}



