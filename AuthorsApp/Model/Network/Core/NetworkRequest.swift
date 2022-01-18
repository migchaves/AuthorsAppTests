//
//  NetworkRequest.swift
//  AuthorsApp
//
//  Created by Miguel on 17/01/2022.
//

import UIKit

final class NetworkRequest {

    // MARK: - Variables
    
    private var request: URLRequest?
    private var task: URLSessionDataTask?
    
    // MARK: - Init
    
    /// Init a NetworkRequest object with the given configuration
    ///
    /// - Parameters:
    ///   - endPoint: the endpoint
    ///   - method: the http method (GET, POST, etc)
    ///   - json: the json object (optional)
    convenience init(endPoint: String, method: HttpMethod, json: NSDictionary?) {
        
        self.init()
        
        self.configureRequest(
            endPoint: endPoint,
            method: method,
            json: json)
    }
    
    // MARK: - Send and Cancel request
    
    /// Send the request to the given endpoint
    ///
    /// - Parameters:
    ///   - success: the success callback
    ///   - failure: the failure callback
    func send(success: @escaping SuccessBlock, failure: @escaping FailureBlock) {
        
        guard self.request != nil else {
            DispatchQueue.main.async {
                failure(nil)
            }
            return
        }
        
        self.task = URLSession.shared.dataTask(with: self.request!, completionHandler: { (data, response, error) in
            
            // Check for response
            guard let httpResponse = response as? HTTPURLResponse else {
                
                DispatchQueue.main.async {
                    failure(nil)
                }
                return
            }
            
            // Ensure the server responds with status code 200
            guard httpResponse.statusCode == 200 else {
                
                if error != nil {
                    DispatchQueue.main.async {
                        failure(error!.localizedDescription)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    failure("Status code: \(httpResponse.statusCode)")
                }
                
                return
            }
            
            guard data != nil else {
                
                DispatchQueue.main.async {
                    failure("No data")
                }
                
                return
            }
            
            DispatchQueue.main.async {
                success(data!)
            }
        })
        
        self.task?.resume()
    }
    
    /// Cancel the current request
    func cancel() {
        self.task?.cancel()
    }
    
    // MARK: - Configure Request
    
    /// Private func to configure the request
    ///
    /// - Parameters:
    ///   - endPoint: the endpoint
    ///   - method: the http method
    ///   - json: the json object
    private func configureRequest(
        endPoint: String,
        method: HttpMethod,
        json: NSDictionary?) {
        
        guard let url = URL(string: endPoint.replacingOccurrences(of: "//", with: "/")) else {
            return
        }
        
        self.request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: RequestValues.timeOut)
        
        self.request?.httpMethod = method.rawValue
        
        if (method == .POST || method == .PUT) {
            request?.addValue(
                RequestValues.contentTypeJsonValue,
                forHTTPHeaderField: RequestValues.contentTypeHeader)
        }
        
        if let wrappedJson = json {
            
            do {
                let data = try JSONSerialization.data(
                    withJSONObject: wrappedJson,
                    options: .prettyPrinted)
                
                request?.httpBody = data
                
            } catch {
                print("Error creating request")
            }
        }
    }
}
