//
//  Structs.swift
//  AuthorsApp
//
//  Created by Miguel on 17/01/2022.
//

import UIKit

// MARK: - Structs

struct AuthorObject: Decodable {
    
    var key: String?
    var type: String?
    var name: String?
    var birth_date: String?
    var top_work: String?
    var work_count: Int?
    var top_subjects: [String]?
    var _version_: Int?
}

struct AuthorResponseObject: Decodable {
    
    var numFound: Int?
    var start: Int?
    var numFoundExact: Bool?
    var docs: [AuthorObject]?
}
