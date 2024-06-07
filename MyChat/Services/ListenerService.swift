//
//  ListenerService.swift
//  MyChat
//
//  Created by white4ocolate on 19.05.2024.
//

import Firebase
import FirebaseFirestore

class ListenerService {
    static let shared = ListenerService()
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    private var currentUserID: String {
        return Auth.auth().currentUser!.uid
    }
    
    func usersObserve(users: [MyUser], completion: @escaping (Result<[MyUser], Error>) -> ()) -> ListenerRegistration? {
        var users = users
        let usersListener = usersRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { diff in
                guard let myuser = MyUser(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !users.contains(myuser) else { return }
                    guard myuser.id != self.currentUserID else { return }
                    users.append(myuser)
                case .modified:
                    guard let index = users.firstIndex(of: myuser) else { return }
                    users[index] = myuser
                case .removed:
                    guard let index = users.firstIndex(of: myuser) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return usersListener
    }
    
    func waitingChatsObserve(waitingChats: [MyChat], completion: @escaping (Result<[MyChat], Error>) -> ()) -> ListenerRegistration? {
        var waitingChats = waitingChats
        let waitingChatsRef = db.collection(["users", currentUserID, "waitingChats"].joined(separator: "/"))
        let waitingChatsListener = waitingChatsRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { diff in
                guard let mychat = MyChat(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !waitingChats.contains(mychat) else { return }
                    waitingChats.append(mychat)
                case .modified:
                    guard let index = waitingChats.firstIndex(of: mychat) else { return }
                    waitingChats[index] = mychat
                case .removed:
                    guard let index = waitingChats.firstIndex(of: mychat) else { return }
                    waitingChats.remove(at: index)
                }
            }
            completion(.success(waitingChats))
        }
        return waitingChatsListener
    }
    
    func activeChatsObserve(activeChats: [MyChat], completion: @escaping (Result<[MyChat], Error>) -> ()) -> ListenerRegistration? {
        var activeChats = activeChats
        let activeChatsRef = db.collection(["users", currentUserID, "activeChats"].joined(separator: "/"))
        let activeChatsListener = activeChatsRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { diff in
                guard let mychat = MyChat(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !activeChats.contains(mychat) else { return }
                    activeChats.append(mychat)
                case .modified:
                    guard let index = activeChats.firstIndex(of: mychat) else { return }
                    activeChats[index] = mychat
                case .removed:
                    guard let index = activeChats.firstIndex(of: mychat) else { return }
                    activeChats.remove(at: index)
                }
            }
            completion(.success(activeChats))
        }
        return activeChatsListener
    }
    
    func messagesObserve(chat: MyChat, completion: @escaping (Result<MyMessage, Error>) -> ()) -> ListenerRegistration? {
        let ref = usersRef.document(currentUserID).collection("activeChats").document(chat.friendID).collection("messages")
        let messageListener = ref.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { diff in
                guard let message = MyMessage(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    completion(.success(message))
                case .modified:
                    break
                case .removed:
                    break
                }
            }
        }
        return messageListener
    }
}
