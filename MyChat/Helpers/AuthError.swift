//
//  AuthError.swift
//  MyChat
//
//  Created by white4ocolate on 01.05.2024.
//

import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case passwordsNotMatched
    case unownError
    case serverError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Please fill all fields", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Please enter valid email", comment: "")
        case .passwordsNotMatched:
            return NSLocalizedString("Your passwords doesn't match", comment: "")
        case .unownError:
            return NSLocalizedString("Something went wrong...", comment: "")
        case .serverError:
            return NSLocalizedString("Server Error...", comment: "")
        }
    }
}
