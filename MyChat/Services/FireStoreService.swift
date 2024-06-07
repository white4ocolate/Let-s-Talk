//
//  FireStoreService.swift
//  MyChat
//
//  Created by white4ocolate on 02.05.2024.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class FireStoreService {
    static let shared = FireStoreService()
    let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    private var waitingChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    private var activeChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
    }
    var currentUser: MyUser!
    
    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<MyUser, Error>) -> ()) {
        guard Validators.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != #imageLiteral(resourceName: "avatar") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        var myUser = MyUser(id: id,
                            email: email,
                            username: username!,
                            avatarStringURL: "not exist",
                            description: description!,
                            sex: sex!)
        StorageService.shared.upload(photo: avatarImage!) { (result) in
            switch result {
            case .success(let url):
                myUser.avatarStringURL = url.absoluteString
                self.usersRef.document(myUser.id).setData(myUser.respresentation) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(myUser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserData(user: User, completion: @escaping (Result<MyUser, Error>) -> ()) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let myUser = MyUser(document: document) else {
                    completion(.failure(UserError.cantUnwrapData))
                    return
                }
                self.currentUser = myUser
                completion(.success(myUser))
            } else {
                completion(.failure(UserError.infoNotExist))
            }
        }
    }
    
    func createWaitingChat(message: String, receiver: MyUser, completion: @escaping (Result<Void, Error>) -> ()) {
        let reference = db.collection(["users", receiver.id, "waitingChats"].joined(separator: "/"))
        let messageRef = reference.document(self.currentUser.id).collection("messages")
        let message = MyMessage(user: currentUser, content: message)
        let chat = MyChat(friendUsername: currentUser.username,
                          friendAvatarStringURL: currentUser.avatarStringURL,
                          lastMessage: message.content,
                          friendID: currentUser.id)
        reference.document(currentUser.id).setData(chat.respresentation) { error in
            if let error = error {
                completion(.failure(error))
            }
            messageRef.addDocument(data: message.respresentation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
    
    func removeWaitingChat(chat: MyChat, completion: @escaping (Result<Void, Error>) -> ()) {
        waitingChatsRef.document(chat.friendID).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(Void()))
            self.removeMessages(chat: chat, completion: completion)
        }
    }
    
    func removeMessages(chat: MyChat, completion: @escaping (Result<Void, Error>) -> ()) {
        let reference = waitingChatsRef.document(chat.friendID).collection("messages")
        getWaitingChatMessages(chat: chat) { result in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentID = message.id else { return }
                    let messageRef = reference.document(documentID)
                    messageRef.delete { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWaitingChatMessages(chat: MyChat, completion: @escaping (Result<[MyMessage], Error>) -> ()) {
        let reference = waitingChatsRef.document(chat.friendID).collection("messages")
        var messages = [MyMessage]()
        reference.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                guard let message = MyMessage(document: document) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
    func changeToActive(chat: MyChat, completion: @escaping (Result<Void, Error>) -> ()) {
        getWaitingChatMessages(chat: chat) { result in
            switch result {
            case .success(let messages):
                self.removeWaitingChat(chat: chat) { result in
                    switch result {
                    case .success():
                        self.createActiveChat(chat: chat, messages: messages) { result in
                            switch result {
                            case .success():
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createActiveChat(chat: MyChat, messages: [MyMessage], completion: @escaping (Result<Void, Error>) -> ()) {
        let messageRef = activeChatsRef.document(chat.friendID).collection("messages")
        activeChatsRef.document(chat.friendID).setData(chat.respresentation) { error in
            if let error = error {
                completion(.failure(error))
            }
            for message in messages {
                messageRef.addDocument(data: message.respresentation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    
    func sendMessage(chat: MyChat, message: MyMessage, completion: @escaping (Result<Void, Error>) -> ()) {
        //активный чат со мной у моего собеседника
        let friendRef = usersRef.document(chat.friendID).collection("activeChats").document(currentUser.id)
        let friendMessageRef = friendRef.collection("messages")
        
        //активный чат с другом у меня
        let myRef = usersRef.document(currentUser.id).collection("activeChats").document(chat.friendID)
        let myMessageRef = myRef.collection("messages")
        
        let chatForFriend = MyChat(friendUsername: currentUser.username,
                                   friendAvatarStringURL: currentUser.avatarStringURL,
                                   lastMessage: message.content,
                                   friendID: currentUser.id)
        //создаем активный чат у друга
        friendRef.setData(chatForFriend.respresentation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            //добавляем дуруг новое сообщение
            friendMessageRef.addDocument(data: message.respresentation) { error in
                if let error =  error {
                    completion(.failure(error))
                    return
                }
                //добавляем новое сообщение себе
                myMessageRef.addDocument(data: message.respresentation) { error in
                    if let error =  error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
}
