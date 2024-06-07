//
//  GoogleViewController.swift
//  MyChat
//
//  Created by white4ocolate on 16.05.2024.
//

import Foundation
import GoogleSignIn
import FirebaseCore

class GoogleViewController: UIViewController {
    func googleSignIn(controller: UIViewController){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: controller) { result, error in
            guard error == nil else {
                return
            }
            if let user = result?.user {
                AuthService.shared.googleLogIn(user: user, error: error, completion: { (result) in
                    switch result {
                    case .success(let user):
                        FireStoreService.shared.getUserData(user: user) { (result) in
                            switch result {
                            case .success(let myuser):
                                let mainTabBar = MainTabBarController(currentUser: myuser)
                                mainTabBar.modalPresentationStyle = .fullScreen
                                controller.present(mainTabBar, animated: true)
                            case .failure(_):
                                controller.showAlert(with: "Success", message: "You have successfully registered!") {
                                    controller.present(SetupProfileViewController(currentUser: user), animated: true)
                                }
                            }
                        }
                    case .failure(_):
                        controller.showAlert(with: "Error with Google Login", message: error!.localizedDescription)
                    }
                })
            } else {
                controller.showAlert(with: "Error with Google", message: error!.localizedDescription)
                return
            }
        }
    }
}
