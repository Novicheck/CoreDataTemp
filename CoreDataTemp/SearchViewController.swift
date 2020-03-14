//
//  SearchViewController.swift
//  CoreDataTemp
//
//  Created by Denis on 12.03.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    private let cellId = "cell"
    var filteredTask:[Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print (filteredTask.count)
        return filteredTask.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let taskName = filteredTask[indexPath.row].name
        cell.textLabel?.text = taskName
        cell.textLabel?.numberOfLines = 0
        return cell
    }

}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        if let filteredArray = DataManager.shared.search(text: searchText) {
            filteredTask = filteredArray
            print(filteredTask)
        }
        tableView.reloadData()
    }
}
