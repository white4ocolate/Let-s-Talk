//
//  ChatConfigureCell.swift
//  MyChat
//
//  Created by white4ocolate on 23.04.2024.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U)
}
