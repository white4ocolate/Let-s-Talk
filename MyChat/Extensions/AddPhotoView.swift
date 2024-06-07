//
//  AddPhotoView.swift
//  MyChat
//
//  Created by white4ocolate on 15.04.2024.
//

import UIKit

class AddPhotoView: UIView {
    
    var circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "avatar")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        
        return imageView
    }()
    
//    let plusButton: UIButton = {
//        let button = UIButton(type: .system)
//        let myImage = #imageLiteral(resourceName: "plus")
//        button.setImage(myImage, for: .normal)
//        button.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        return button
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleImageView.layer.masksToBounds = true
        circleImageView.layer.cornerRadius = circleImageView.frame.width / 2
    }
}

extension AddPhotoView {
    private func setupConstraints() {
        circleImageView.translatesAutoresizingMaskIntoConstraints = false
//        plusButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(circleImageView)
//        addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            circleImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            circleImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circleImageView.heightAnchor.constraint(equalToConstant: 100),
            circleImageView.widthAnchor.constraint(equalToConstant: 100),
            circleImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
//        NSLayoutConstraint.activate([
//            plusButton.leadingAnchor.constraint(equalTo: circleImageView.trailingAnchor, constant: 16),
//            plusButton.centerYAnchor.constraint(equalTo: circleImageView.centerYAnchor),
//            plusButton.heightAnchor.constraint(equalToConstant: 30),
//            plusButton.widthAnchor.constraint(equalToConstant: 30)
//        ])
        
    }
}
