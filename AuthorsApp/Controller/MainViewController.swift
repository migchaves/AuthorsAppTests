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
    
    // MARK: - Vars
    
    private var sourceArray = [AuthorObject]() {
        didSet {
            
            guard self.sourceArray.count > 0 else {
                return
            }
            
            self.tableView.reloadData()
        }
    }

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Search Authors"
        
        self.loadData()
    }

    // MARK: - Handle info
    
    /// Load data from server
    private func loadData() {
        
        AppRequests.search(author: "Tolkien") { [weak self] items in
                
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
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ReuseIdentifiers.homeCell,
            for: indexPath)
        
        let author = self.sourceArray[indexPath.row]
        
        cell.textLabel?.text = author.name ?? "---"
        cell.detailTextLabel?.text = "\(author.work_count ?? 0) works"
        
        return cell
    }
}
