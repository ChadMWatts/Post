//
//  PostController.swift
//  Post
//
//  Created by Chad Watts on 6/6/16.
//  Copyright © 2016 Chad Watts. All rights reserved.
//

import Foundation

class PostController {
    
    static let baseURL = NSURL(string: "https://devmtn-post.firebaseio.com/posts/")
    static let endpoint = baseURL?.URLByAppendingPathExtrension("json")
    
    weak var delegate: PostControllerDelegate?
    
    var posts: [Post] = [] {
        
        didSet {
            delegate?.postsupdated(posts)
        }
    }
    
    init() {
        
    }
    
    func addPost(username: String, text: String) {
        
        let post = Post(username: username, text: text)
        
        guard let requestURL = post.endpoint else { faltalError("URL optional is nil") }
        
        NetworkController.performRequestForURL(requestURL, httpMethod: .Put, body: post.jsonData) { (data, error) in
            let resposeDataString = NSString(data: data!, encoding: NSUTF8StringEncoding) ?? ""
            
            if error != nil {
                print("Error: |(error)")
            } else if resposeDataString.containsString("error") {
                print("Error: \(resposeDataString)")
            } else {
                print("Successfully savved data to endppoint. \nResponse: \(resposeDataString)")
            }
            
            self.fetchPosts()
        }
    }
    
}


func fetchPosts(reset reset: Bool = true, completion: ((newPosts: [Post]) -> Void)? = nil) {
    
    guard let requestURL = PostController.endpoint else { faltalError("Post Endpint url failed") }
    let queryEndInterval = reset ? NSDate().timeIntervalSince1970 : post.last.queryTimeStamp ?? NSDate().timeIntervalSince1970
    
    //TODO: update to query timestamp
    
    let urlParameters = [
        "orderBy": "\"timestamp\""
        "endAt": "\(queryEndInterval)"
        "limitToLast": "15",
    ]
    
    NetworkController.performRequestForURL(requestURL, httpMethod: .Get, urlParameters:  urlParameters) { (data, error) in
        let responseDataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        guard let data = data,
            let postDictionaries = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String: [String:AnyObject]] else {
                
                print("Unable to serialize JSON. \nResponse: \(responseDataString)")
                if let completion = completion {
                    completion(newPosts: [])
                }
                
                return
        }
        
        let posts = postDictionaries.flatMap({Post(json: $0.1, identifier: $0.0)})
        let sortedPosts = posts.sort({$0.0.timestamp > $0.1.timestamp})
        
        dispatch_async(dispatch_get_main_queue(), {
            
            if reset {
                self.posts = sortedPosts
            } else {
                self.posts.appendContentsOf(sortedPosts)
            }
            
            return
        })
    }
}


protocol PostControllerDelegate: class {
    
    func postsUpdated(posts: [Post])
}














