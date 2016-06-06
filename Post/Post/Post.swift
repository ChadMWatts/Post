//
//  Post.swift
//  Post
//
//  Created by Chad Watts on 6/6/16.
//  Copyright © 2016 Chad Watts. All rights reserved.
//

import Foundation

struct Post {
    
    let Username: String
    let text: String
    let timestamp: NSTimeInterval
    let identifier: NSUUID
    
    init(username: String, text: String, timestamp: NSTimeInterval, identifier: NSUUID) {
        
    }
    
    init?(JSONdictionary: [String:AnyOBject]){
        
    }
}
    

