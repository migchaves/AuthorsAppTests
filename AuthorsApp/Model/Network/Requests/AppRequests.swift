//
//  AppRequests.swift
//  AuthorsApp
//
//  Created by Miguel on 17/01/2022.
//

import UIKit

class AppRequests: NSObject {
    
    /// Search for authors
    /// - Parameters:
    ///   - author: the term to search
    ///   - callback: the callback
    public static func search(author: String, callback: @escaping RequestCallback<[AuthorObject]>) {
        
        let request = NetworkRequest(
            endPoint: RequestEndpoints.searchAuthor + author,
            method: .GET,
            json: nil)
        
        request.send { data in
            
            guard let response = try? JSONDecoder().decode(AuthorResponseObject.self, from: data) else {
                
                DispatchQueue.main.async {
                    callback(nil)
                }
                
                return
            }
            
            guard let items = response.docs else {
                
                DispatchQueue.main.async {
                    callback(nil)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                callback(items)
            }
            
        } failure: { message in
            
            print("Network request failed with error: \(message ?? "--")")
            
            DispatchQueue.main.async {
                callback(nil)
            }
        }
    }
}
