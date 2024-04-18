//
//  User.swift
//  Pet adoption
//
//  Created by Srilakshmi on 4/11/24.
//

import Foundation

struct User {
    let uid: String
    let name: String
    let email: String
    let username:String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["mobile"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["mobile"] as? String ?? ""
    }
}
 
