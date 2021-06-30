//
//  Constant.swift
//  ChatProject
//
//  Created by Mohammed on 6/20/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

let islive   = false

struct Constant {
    
    //MARK: FireBaseConstant
    static let DBRefrence    = islive ? Database.database().reference().child("live") : Database.database().reference().child("test")
    static var StorageRef    = Storage.storage().reference()
    
    //Recent Tree
    static let RecentNode     = "Recent"
    static let Seen           = "Seen"
    static let UserNode       = "Users"
    static let chatRoomsNode  = "chat_rooms"
    
    static let Conversation   = "Conversation"
    static let counter        = "counter"
    
    //    chat rooms Tree
    static let TypeStatus     = "TypeStatus"
    static let TypeIndicator  = "TypeIndicator"
    static let messages       = "messages"
    static let Active         = "Active"
    static let lastMessage    = "lastMessage"
    
    
    static let RecentNodes        = DBRefrence.child(RecentNode)
    static let ConversationNodes  = DBRefrence.child(Conversation)
    static let UserNodes          = DBRefrence.child(UserNode)
    static let SeenNodes          = DBRefrence.child(Seen)
    
    static let  UserNoAvailable   = "This user is currently unavailable for chat"
    static let Admin_Id = 0
    
    
}
