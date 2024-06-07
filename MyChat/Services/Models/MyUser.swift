//
//  MyUsers.swift
//  MyChat
//
//  Created by white4ocolate on 26.04.2024.
//

import UIKit
import FirebaseFirestore

struct MyUser: Hashable, Decodable {
    var id: String
    var email: String
    var username: String
    var avatarStringURL: String
    var description: String
    var sex: String
    
    var respresentation: [String: Any] {
        let dictionary = ["uid": id,
                          "email": email,
                          "username": username,
                          "avatarStringURL": avatarStringURL,
                          "description": description,
                          "sex": sex
        ]
        return dictionary
    }
    
    init(id: String, email: String, username: String, avatarStringURL: String, description: String, sex: String){
        self.id = id
        self.email = email
        self.username = username
        self.avatarStringURL = avatarStringURL
        self.description = description
        self.sex = sex
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let username = data["username"] as? String,
              let uid = data["uid"] as? String,
              let sex = data["sex"] as? String,
              let email = data["email"] as? String,
              let description = data["description"] as? String,
              let avatarStringURL = data["avatarStringURL"] as? String
        else { return nil }
        self.username = username
        self.id = uid
        self.sex = sex
        self.email = email
        self.description = description
        self.avatarStringURL = avatarStringURL
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let username = data["username"] as? String,
              let uid = data["uid"] as? String,
              let sex = data["sex"] as? String,
              let email = data["email"] as? String,
              let description = data["description"] as? String,
              let avatarStringURL = data["avatarStringURL"] as? String
        else { return nil }
        self.username = username
        self.id = uid
        self.sex = sex
        self.email = email
        self.description = description
        self.avatarStringURL = avatarStringURL
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: MyUser, rhs: MyUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    func contains(searchText: String?) -> Bool {
        guard let filter = searchText else { return true }
        if filter.isEmpty { return true }
        let lowerCasedText = filter.lowercased()
        return username.lowercased().contains(lowerCasedText)
    }
}
