//
//  WaitingChatsNavigation.swift
//  MyChat
//
//  Created by white4ocolate on 21.05.2024.
//

import Foundation

protocol WaitingChatsNavigation: class {
    func removeWaitingChat(chat: MyChat)
    func toActiveChat(chat: MyChat)
}
