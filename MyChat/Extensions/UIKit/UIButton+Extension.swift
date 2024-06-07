//
//  UIButtin+Extension.swift
//  MyChat
//
//  Created by white4ocolate on 12.04.2024.
//

import UIKit

extension UIButton {
    
    convenience init(backgroundColor: UIColor = .white, title: String, titleColor: UIColor, font: UIFont? = UIFont.avenir20(), cornerRadius: CGFloat = 4, isShadow: Bool = true) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    
    func customizeGoogleButton(){
        let googleLogo = UIImageView(image: #imageLiteral(resourceName: "googleLogo"), contentMode: .scaleAspectFit)
        
        googleLogo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(googleLogo)
        
        NSLayoutConstraint.activate([
            googleLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            googleLogo.topAnchor.constraint(equalTo: self.topAnchor, constant: 20)
        ])
    }
}
