//
//  ProfileViewController.swift
//  MyChat
//
//  Created by white4ocolate on 29.04.2024.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    let containerView = UIView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human3"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Reese Witherspoon", font: .systemFont(ofSize: 20, weight: .light))
    let aboutMeLabel = UILabel(text: "You have the opportunity to chat with best girl in the world!", font: .systemFont(ofSize: 16, weight: .light))
    let myTextField = InsertableTextField()

    private let user: MyUser
    
    init(user: MyUser) {
        self.user = user
        self.nameLabel.text = user.username
        self.aboutMeLabel.text = user.description
        self.imageView.sd_setImage(with: URL(string: user.avatarStringURL))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        myTextField.borderStyle = .roundedRect
        customizeElements()
        setUpContraints()
    }
}
extension ProfileViewController {
    private func setUpContraints(){
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(myTextField)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30)
        ])
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 210)
        ])
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            myTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            myTextField.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 10),
            myTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            myTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func customizeElements() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        myTextField.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.numberOfLines = 0
        containerView.backgroundColor = .mainWhite
        containerView.layer.cornerRadius = 30
        containerView.clipsToBounds = true
        
        if let sendButton = myTextField.rightView as? UIButton {
            sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
    }
    
    @objc private func sendMessage() {
        guard let message = myTextField.text else { return }
        self.dismiss(animated: true) {
            FireStoreService.shared.createWaitingChat(message: message, receiver: self.user) { result in
                switch result {
                case .success():
                    UIApplication.getTopViewController()?.showAlert(with: "Success", message: message)
                case .failure(let error):
                    UIApplication.getTopViewController()?.showAlert(with: "Error", message: error.localizedDescription)
                }
            }
        }
    }
}
