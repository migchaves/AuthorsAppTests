//
//  Static.swift
//  AuthorsApp
//
//  Created by Miguel on 18/01/2022.
//

import UIKit

// MARK: - Reuse identifiers

struct ReuseIdentifiers {
    static let homeCell = "homeCell"
}

// MARK: - Acessibility identifiers

struct AccessibilityIdentifiers {
    
    struct Home {
        static let searchBar = "HomeSearchBar"
        static let tableView = "HomeTableView"
    }
}

// MARK: - Segues

struct Segue {
    
    static let toDetails = "segueToDetails"
}
