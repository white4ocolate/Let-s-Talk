//
//  UserError.swift
//  MyChat
//
//  Created by white4ocolate on 06.05.2024.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
    case infoNotExist
    case cantUnwrapData
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Please fill all fields", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Please add photo to your profile", comment: "")
        case .infoNotExist:
            return NSLocalizedString("Cant load info about user from Firebase", comment: "")
        case .cantUnwrapData:
            return NSLocalizedString("Cant unwrap data to MyUser", comment: "")
        }
    }
}
