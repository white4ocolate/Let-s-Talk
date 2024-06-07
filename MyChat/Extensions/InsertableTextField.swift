//
//  InsertableTextField.swift
//  MyChat
//
//  Created by white4ocolate on 29.04.2024.
//

import UIKit

class InsertableTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        placeholder = "Write something here ..."
        font = .systemFont(ofSize: 14)
        clearButtonMode = .whileEditing
        borderStyle = .none
        layer.cornerRadius = 18
        layer.masksToBounds = true
        
        let smileImage = UIImage(systemName: "smiley")
        let smaileImageView = UIImageView(image: smileImage)
        smaileImageView.setupColor(color: .lightGray)
        leftView = smaileImageView
        leftView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        leftViewMode = .always
        
        let sendButton = UIButton(type: .system)
        sendButton.setImage(UIImage(named: "Sent"), for: .normal)
//        sendButton.applyGradients(cornerRadius: 10)
        rightView = sendButton
        rightView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        rightViewMode = .always
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x += -12
        return rect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

