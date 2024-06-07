//
//  MyChat.swift
//  MyChat
//
//  Created by white4ocolate on 26.04.2024.
//

import UIKit
import FirebaseFirestore

struct MyChat: Hashable, Decodable {
    var friendUsername: String
    var friendAvatarStringURL: String
    var lastMessage: String
    var friendID: String
    
    var respresentation: [String: Any] {
        let dictionary = ["friendUsername": friendUsername,
                          "friendAvatarStringURL": friendAvatarStringURL,
                          "lastMessage": lastMessage,
                          "friendID": friendID
        ]
        return dictionary
    }
    
    init(friendUsername: String, friendAvatarStringURL: String, lastMessage: String, friendID: String) {
        self.friendUsername = friendUsername
        self.friendAvatarStringURL = friendAvatarStringURL
        self.lastMessage = lastMessage
        self.friendID = friendID
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let friendUsername = data["friendUsername"] as? String,
              let friendAvatarStringURL = data["friendAvatarStringURL"] as? String,
              let lastMessage = data["lastMessage"] as? String,
              let friendID = data["friendID"] as? String
        else { return nil }
        self.friendUsername = friendUsername
        self.friendAvatarStringURL = friendAvatarStringURL
        self.lastMessage = lastMessage
        self.friendID = friendID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendID)
    }
    static func == (lhs: MyChat, rhs: MyChat) -> Bool {
        return lhs.friendID == rhs.friendID
    }
}
