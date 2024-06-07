//
//  ChatRequestViewController.swift
//  MyChat
//
//  Created by white4ocolate on 30.04.2024.
//

import UIKit
import SDWebImage

class ChatRequestViewController: UIViewController {
    
    let containerView = UIView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human10"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Maksim", font: .systemFont(ofSize: 20, weight: .light))
    let aboutMeLabel = UILabel(text: "Научусь летать с тобой на небо там, где звёзды до рассвета говорят телами о любви!", font: .systemFont(ofSize: 16, weight: .light))
    let acceptButton = UIButton(backgroundColor: .black, title: "ACCEPT", titleColor: .white, font: .laoSangamMN20(), cornerRadius: 10, isShadow: false)
    let denyButton = UIButton(backgroundColor: .mainWhite, title: "DENY", titleColor: #colorLiteral(red: 0.8756850362, green: 0.2895075381, blue: 0.2576965988, alpha: 1), font: .laoSangamMN20(), cornerRadius: 10, isShadow: false)
    private var chat: MyChat
    
    weak var delegate:WaitingChatsNavigation?
    
    init(chat: MyChat) {
        self.chat = chat
        self.nameLabel.text = chat.friendUsername
        self.imageView.sd_setImage(with: URL(string: chat.friendAvatarStringURL))
        self.aboutMeLabel.text = chat.lastMessage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite
        customizeElements()
        setUpContraints()
        
        denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    @objc private func denyButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.removeWaitingChat(chat: self.chat)
        }
    }
    
    @objc private func acceptButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.toActiveChat(chat: self.chat)
        }
    }
    
}
extension ChatRequestViewController {
    private func customizeElements() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        denyButton.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.numberOfLines = 0
        containerView.backgroundColor = .mainWhite
        containerView.layer.cornerRadius = 30
        containerView.clipsToBounds = true
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = #colorLiteral(red: 0.8756850362, green: 0.2895075381, blue: 0.2576965988, alpha: 1)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.acceptButton.applyGradients(cornerRadius: 10)
    }
    
    private func setUpContraints() {
        let buttonsStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 7)
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(buttonsStackView)
        
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
            buttonsStackView.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 25),
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 55),
            buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
        
    }
}
//#Preview {
//    ChatRequestViewController()
//}
