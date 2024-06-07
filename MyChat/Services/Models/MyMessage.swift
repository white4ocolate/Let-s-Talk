//
//  MyMessage.swift
//  MyChat
//
//  Created by white4ocolate on 20.05.2024.
//

import UIKit
import FirebaseFirestore
import MessageKit

struct ImageItem: MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
}

struct MyMessage: Hashable, MessageType, Comparable {
    let content: String
    let sentDate: Date
    let id: String?
    var messageId: String {
        return id ?? UUID().uuidString
    }
    var kind: MessageKit.MessageKind {
        if let image = image {
            let imageItem = ImageItem(placeholderImage: image, size: image.size)
            return .photo(imageItem)
        } else {
            return .text(content)
        }
    }
    var sender: any MessageKit.SenderType
    
    var image: UIImage? = nil
    var dowloadURL: URL? = nil
    
    var respresentation: [String: Any] {
        var dictionary: [String : Any] = ["sendredID": sender.senderId,
                                          "senderUsername": sender.displayName,
                                          "created": sentDate
        ]
        if let url = dowloadURL {
            dictionary["url"] = url.absoluteString
        } else {
            dictionary["content"] = content
        }
        return dictionary
    }
    
    static func < (lhs: MyMessage, rhs: MyMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
    static func == (lhs: MyMessage, rhs: MyMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
//        guard let content = data["content"] as? String else { return nil }
        guard let sendredID = data["sendredID"] as? String else { return nil }
        guard let senderUsername = data["senderUsername"] as? String else { return nil }
        guard let sentDate = data["created"] as? Timestamp else { return nil }
        
        self.id = document.documentID
        sender = Sender(senderId: sendredID, displayName: senderUsername)
        self.sentDate = sentDate.dateValue()
        
        if let content = data["content"] as? String {
            self.content = content
            self.dowloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            self.dowloadURL = url
            self.content = ""
        } else {
            return nil
        }
    }
    
    init(user: MyUser, content: String) {
        self.content = content
        sender = Sender(senderId: user.id, displayName: user.username)
        self.sentDate = Date()
        self.id = nil
    }
    
    init(user: MyUser, image: UIImage) {
        sender = Sender(senderId: user.id, displayName: user.username)
        self.image = image
        self.content = ""
        self.sentDate = Date()
        self.id = nil
    }
}
