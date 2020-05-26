//
//  TableVC.swift
//  AgeOfEmpiresInfo
//
//  Created by user on 25/05/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {
    
    var civilizations: [Civilization] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.separatorStyle = .singleLine
            }
        }
    }
    var filteredCivilizations: [Civilization] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    var indicator = UIActivityIndicatorView()
    var progressView = UIProgressView(progressViewStyle: .default)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // civilizations = СivilizationList.civilizations() // mock json

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Civilizations"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = Civilization.Expansion.allCases.map { $0.rawValue }
        searchController.searchBar.delegate = self
        
        setUpActivityIndicator()
        loadData()

    }
    
    func setUpActivityIndicator() {
//        indicator.center = self.view.center
//        indicator.hidesWhenStopped = true
//        indicator.style = UIActivityIndicatorView.Style.gray
//        self.view.addSubview(indicator)
        
        progressView.center = view.center
        progressView.trackTintColor = UIColor.lightGray
        progressView.tintColor = UIColor.blue
        view.addSubview(progressView)
    }
    
    func loadData() {
        self.indicator.startAnimating()
        self.tableView.separatorStyle = .none
        AgeOfEmpiresServiceImp.getCivilizations(completion: {civilizations, error  in
            self.civilizations = civilizations ?? []
            self.progressView.isHidden = true
            self.indicator.stopAnimating()
        }, progressCompletion: {progress in
            print(String(format: "%.1f%%", progress * 100))
            DispatchQueue.main.async {
                self.progressView.setProgress(Float(progress), animated: false)
            }
            
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCivilizations.count
        }
        
        return civilizations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CivilizationCell", for: indexPath) as? CivilizationCell else {
            fatalError()
        }
        let civilization: Civilization
        if isFiltering {
            civilization = filteredCivilizations[indexPath.row]
        } else {
            civilization = civilizations[indexPath.row]
        }
        
        cell.setup(with: civilization)
       
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "DetailVC") as? DetailVC else {
                return
        }
        
        let civilization: Civilization
        if isFiltering {
            civilization = filteredCivilizations[indexPath.row]
        } else {
            civilization = civilizations[indexPath.row]
        }
        
        viewController.civilization = civilization
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Table filter
    
    func filterContentForSearchText(_ searchText: String,
                                    expansion: Civilization.Expansion? = nil) {

        filteredCivilizations = civilizations.filter { (civilization: Civilization) -> Bool in
            let doesExpansionMatch = expansion == .all || civilization.expansion == expansion
            
            if isSearchBarEmpty {
                return doesExpansionMatch
            } else {
                return doesExpansionMatch && civilization.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }

}

extension TableVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let expansion = Civilization.Expansion(rawValue:
            searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        filterContentForSearchText(searchBar.text!, expansion: expansion)
    }
}

extension TableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   selectedScopeButtonIndexDidChange selectedScope: Int) {
        let expansion = Civilization.Expansion(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, expansion: expansion)
    }
}
