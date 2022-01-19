//
//  DetailsViewController.swift
//  AuthorsApp
//
//  Created by Miguel on 19/01/2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var topWorkLabel: UILabel!
    @IBOutlet weak var workCountLabel: UILabel!
    @IBOutlet weak var numberSubjectsLabel: UILabel!
    
    // MARK: - Variables
    
    var author: AuthorObject?
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.author?.name ?? "---"
    }
    
    // MARK: - Data handling
    
    /// Bind the data to the labels
    private func bindData() {
        
        self.birthDateLabel.text = self.author?.birth_date ?? "No birthdate"
        self.topWorkLabel.text = self.author?.top_work ?? "No top work"
        
        if let count = self.author?.work_count {
            self.workCountLabel.text = "\(count) work(s)"
        } else {
            self.workCountLabel.text = "No works"
        }
        
        guard let wrapped = self.author?.top_subjects else {
            return
        }
        
        self.numberSubjectsLabel.text = "\(wrapped.count) subject(s)"
    }
}
