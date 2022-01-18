//
//  MainViewController.swift
//  AuthorsApp
//
//  Created by Miguel on 17/01/2022.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        AppRequests.search(author: "Tolkien") { items in
                
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
