//
//  NearblyUserCell.swift
//  MyChat
//
//  Created by white4ocolate on 26.04.2024.
//

import UIKit
import SDWebImage

class NearblyUserCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId = "NearblyUserCell"
    
    let userImageView = UIImageView()
    let userName = UILabel(text: "Username", font: .laoSangamMN20())
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = .white
        
        self.layer.cornerRadius = 4
        
        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 5
        self.containerView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        userImageView.image = nil
    }
    
    func configure<U: Hashable>(with value: U) {
        guard let nearblyUser = value as? MyUser else { return }
        guard let imageURL = URL(string: nearblyUser.avatarStringURL) else { return }
        userImageView.sd_setImage(with: imageURL)
        userImageView.contentMode = .scaleAspectFill
        userName.text = nearblyUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Constraints
extension NearblyUserCell {
    private func setupConstraints() {
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(userName)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            userImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
//            userName.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 0),
            userName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            userName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
//            userName.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
            userName.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
    }
}
