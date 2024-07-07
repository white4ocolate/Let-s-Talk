//
//  MainTabBarController.swift
//  MyChat
//
//  Created by white4ocolate on 16.04.2024.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {
    
    private let currentUser: MyUser
    
    init(currentUser: MyUser = MyUser(id: "defult",
                                      email: "defult",
                                      username: "defult",
                                      avatarStringURL: "defult",
                                      description: "defult",
                                      sex: "defult")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let conversationsVC = ConversationsViewController(currentUser: currentUser)
        let peopleVC = PeopleViewController(currentUser: currentUser)
        
        tabBar.tintColor = #colorLiteral(red: 0.6299046874, green: 0.4648939967, blue: 0.9760698676, alpha: 1)
        let boldconfig = UIImage.SymbolConfiguration.init(weight: .medium)
        let conversationImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldconfig)!
        let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldconfig)!
        
        viewControllers =
        [
            generateNavigationController(rootVC: peopleVC, title: "People", image: peopleImage),
            generateNavigationController(rootVC: conversationsVC, title: "Conversations", image: conversationImage)
            
        ]
        
    }
    
    private func generateNavigationController(rootVC: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
    }
}
