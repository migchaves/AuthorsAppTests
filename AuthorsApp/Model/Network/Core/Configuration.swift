//
//  Configuration.swift
//  AuthorsApp
//
//  Created by Miguel on 17/01/2022.
//

import UIKit

// General callbacks
typealias FailureBlock = (_ message: String?) -> Void
typealias SuccessBlock = (_ data: Data) -> Void

// Abstract callback
typealias RequestCallback<T> = (_ object: T?) -> Void

// Http Methods
public enum HttpMethod: String {
    case GET, POST, PUT, DELETE
}

// Configuration for request
struct RequestValues {
    
    static let timeOut: TimeInterval = 25.0
    static let authorizationHeader = "Authorization"
    static let contentTypeHeader = "Content-Type"
    static let contentTypeJsonValue = "application/json"
    static let contentTypeWwwForm = "application/x-www-form-urlencoded"
}

// Server Endpoints
struct RequestEndpoints {

    // Private values for the endpoints
    public static let searchAuthor = "https://openlibrary.org/search/authors.json?q="
}
