//
//  StorageService.swift
//  MyChat
//
//  Created by white4ocolate on 16.05.2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class StorageService {
    static let shared = StorageService()
    
    let storageRef = Storage.storage().reference()
    
    private var avatarsRef: StorageReference {
        return storageRef.child("avatars")
    }
    private var chatsRef: StorageReference {
        return storageRef.child("chats")
    }
    
    private var currentUserID: String {
        return Auth.auth().currentUser!.uid
    }
    
    func upload(photo: UIImage, completion: @escaping (Result<URL, Error>) -> ()) {
        guard let scaledPhoto = photo.scaledToSafeUploadSize,
              let photoData = scaledPhoto.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        avatarsRef.child(currentUserID).putData(photoData, metadata: metaData) { (metaData, error) in
            guard let _ = metaData else {
                completion(.failure(error!))
                return
            }
            self.avatarsRef.child(self.currentUserID).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
    }
    
    func uploadImageMessage(image: UIImage, chat: MyChat, completion: @escaping (Result<URL, Error>) -> ()) {
        guard let scaledPhoto = image.scaledToSafeUploadSize,
              let imageData = scaledPhoto.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let myName: String = Auth.auth().currentUser!.displayName!
        let chatName = [chat.friendUsername, myName].joined()
        chatsRef.child(chatName).child(imageName).putData(imageData, metadata: metaData) { (metaData, error) in
            guard let _ = metaData else {
                completion(.failure(error!))
                return
            }
            self.chatsRef.child(chatName).child(imageName).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
    }
    
    func downloadImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> ()) {
        let reference = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        reference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(UIImage(data: imageData)!))
        }
    }
}
