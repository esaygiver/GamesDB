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
    
    lazy var gameData = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDelegations()
    }
    
    func getDelegations() {
        tableView.delegate = self
        tableView.dataSource = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO Segue or instantiate storyboard
    }

}

