//
//  ActiveChatCell.swift
//  MyChat
//
//  Created by white4ocolate on 19.04.2024.
//

import UIKit
import SDWebImage


class ActiveChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId = "ActiveChatCell"
    
    let friendImageView = UIImageView()
    let friendName = UILabel(text: "Username", font: .laoSangamMN20())
    let lastMessage = UILabel(text: "Hello!", font: .laoSangamMN18())
    let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.8577441573, green: 0.7086898685, blue: 1, alpha: 1), endColor: #colorLiteral(red: 0.5460671782, green: 0.7545514107, blue: 0.9380497336, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    func configure<U: Hashable>(with value: U) {
        guard let userChat = value as? MyChat else { return }
        friendImageView.sd_setImage(with: URL(string: userChat.friendAvatarStringURL))
        friendName.text = userChat.friendUsername
        lastMessage.text = userChat.lastMessage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Constraints
extension ActiveChatCell {
    private func setupConstraints() {
        friendImageView.backgroundColor = .orange
        
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendName.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(friendImageView)
        self.addSubview(friendName)
        self.addSubview(lastMessage)
        self.addSubview(gradientView)
        
        NSLayoutConstraint.activate([
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.heightAnchor.constraint(equalToConstant: 78),
            friendImageView.widthAnchor.constraint(equalToConstant: 78)
        ])
        NSLayoutConstraint.activate([
            friendName.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            friendName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            lastMessage.leadingAnchor.constraint(equalTo: friendName.leadingAnchor),
            lastMessage.trailingAnchor.constraint(equalTo: friendName.trailingAnchor),
            lastMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
        NSLayoutConstraint.activate([
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 8)
        ])
    }
}
