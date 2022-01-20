//
//  MainViewController.swift
//  AuthorsApp
//
//  Created by Miguel on 17/01/2022.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Vars
    
    private var sourceArray = [AuthorObject]() {
        didSet {
            
            guard self.sourceArray.count > 0 else {
                self.tableView.isHidden = true
                return
            }
            
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Search Authors"
        
        // Add accessibility id's
        self.searchBar.accessibilityLabel = AccessibilityIdentifiers.Home.searchBar
        self.tableView.accessibilityLabel = AccessibilityIdentifiers.Home.tableView
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toDetails {
            
            if let vc = segue.destination as? DetailsViewController,
               let author = sender as? AuthorObject {
                
                vc.author = author
            }
        }
    }

    // MARK: - Handle info
    
    /// Load data from server
    private func loadData(text: String) {
        
        AppRequests.search(author: text) { [weak self] items in
                
            guard let self = self else {
                return
            }
            
            guard let wrapped = items else {
                return
            }
            
            self.sourceArray = wrapped
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(
            withIdentifier: Segue.toDetails,
            sender: self.sourceArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ReuseIdentifiers.homeCell,
            for: indexPath)
        
        let author = self.sourceArray[indexPath.row]
        
        cell.textLabel?.text = author.name ?? "---"
        cell.textLabel?.accessibilityLabel = AccessibilityIdentifiers.Home.tableCellTitleLabel
        
        cell.detailTextLabel?.text = "\(author.work_count ?? 0) works"
        
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.loadData(text: self.searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
