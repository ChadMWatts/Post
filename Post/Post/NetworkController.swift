//
//  NetworkController.swift
//  Post
//
//  Created by Chad Watts on 6/6/16.
//  Copyright © 2016 Chad Watts. All rights reserved.
//

import Foundation

class NetworkController {
    
    enum HTTPMethod: String {
        
        case Get = "GET"
        case Put = "PUT"
        case Post = "POST"
        case Patch = "PATCH"
        case Delete = "DELETE"
    }
    
    static func performRequestForURL(url: NSURL, httpMethod: HTTPMethod, urlParameters: [String: String]? = nil, body: NSData?, completion: ((data: NSData?, error: NSError?) -> void?) {
        
        let requestURL = urlFromURLParameters(url, urlParameters: urlParameters)
        
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = httpMethod.rawValue
        request.HTTPBody = body
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if let completion = completion {
                completion(data: data, error: error)
            }
        }
        
        dataTask.resume()
    })
    
    static func urlFromURLParameters(url: NSURL, urlParameters: [String: String]?) -> NSURL {
        
        let componets = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
        componets?.queryItems = urlParameters?.flatMap({NSURLQueryItem(name: $0.0, value:  $0.1)})
        
        if let url = componets?.URL {
            return url
        } else {
            fatalError("URL optional is nil")
        }
    }
}






