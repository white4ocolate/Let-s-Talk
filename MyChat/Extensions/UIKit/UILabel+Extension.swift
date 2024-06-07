//
//  UILabel+Extension.swift
//  MyChat
//
//  Created by white4ocolate on 12.04.2024.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        self.text = text
        self.font = font
    }
}
