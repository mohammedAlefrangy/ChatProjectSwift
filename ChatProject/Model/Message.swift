//
//  Message.swift
//  ChatProject
//
//  Created by Mohammed on 6/20/21.
//

import Foundation
import Firebase

struct Message {
    
    var Message       : String
    var SenderUid     : String
    var Sendername    : String
    var SenderImage   : String
    var ReceiverUid   : String
    var Receivername  : String
    var ReceiverImage : String
    var Timestamp     : Int
    var GroupId       : String
    var key           : String = ""
    var mediaType     : String
    var mediaUrl      : String
    var status        : Int
    
    
    init(snapshot: DataSnapshot)
    {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        Message       = snapshotValue["message"] as? String ?? ""
        SenderUid     = snapshotValue["senderUid"] as! String
        Sendername    = snapshotValue["senderName"] as? String ?? ""
        SenderImage   = snapshotValue["senderImage"] as? String ?? ""
        ReceiverUid   = snapshotValue["receiverUid"] as! String
        Receivername  = snapshotValue["receiverName"] as? String ?? ""
        ReceiverImage = snapshotValue["receiverImage"] as? String ?? ""
        Timestamp     = snapshotValue["timestamp"] as! Int
        GroupId       = snapshotValue["groupId"] as? String ?? ""
        mediaType     = snapshotValue["type"] as? String ?? ""
        mediaUrl      = snapshotValue["mediaUrl"] as? String ?? ""
        status        = snapshotValue["status"] as? Int ?? 0
        
        self.key = snapshot.key
    }
    
    
    init(Message       : String ,
         SenderUid     : String,
         Sendername    : String,
         SenderImage   : String,
         ReceiverUid   : String,
         Receivername  : String,
         ReceiverImage : String,
         Timestamp     : Int,
         GroupId       : String,
         mediaType     : String,
         status        : Int,
         mediaUrl      : String)
    {
        self.Message       = Message
        self.SenderUid     = SenderUid
        self.Sendername    = Sendername
        self.SenderImage   = SenderImage
        self.ReceiverImage = ReceiverImage
        self.Receivername  = Receivername
        self.ReceiverUid   = ReceiverUid
        self.Timestamp     = Timestamp
        self.GroupId       = GroupId
        self.key           = GroupId
        self.mediaType     = mediaType
        self.mediaUrl      = mediaUrl
        self.status        = status
    }
    
    
    func toAnyObject() -> Any
    {
        return ["message"       :self.Message,
                "senderUid"     :self.SenderUid,
                "senderName"    :self.Sendername,
                "senderImage"   :self.SenderImage,
                "receiverUid"   :self.ReceiverUid,
                "receiverName"  :self.Receivername,
                "receiverImage" :self.ReceiverImage,
                "timestamp"     :self.Timestamp,
                "groupId"       :self.GroupId,
                "type"          :self.mediaType,
                "status"        :self.status,
                "mediaUrl"      :self.mediaUrl]
    }
}

struct MessageData {
    var senderID       : String?
    var senderName     : String?
    var date           : String?
    var textMessage    : String?
    var Photo          : UIImage?
    var mediaURL       : String?
    var urlFile        : String?
    
    var messageType    : MessageType
}

enum MessageType {
    
    case text
    case file
    case photo
    case video
    case sound
    case None
    
    
    var value : String {
        switch self {
        case .text       : return "text"
        case .file       : return "file"
        case .photo      : return "photo"
        case .video      : return "video"
        case .sound      : return "sound"
        default          : return ""
        }
    }

    init(_ type:String) {
        switch type {
        
        case "text"     : self = .text
        case "file"     : self = .file
        case "photo"    : self = .photo
        case "video"    : self = .video
        case "sound"    : self = .sound
        default         : self = .None
        }
    }
}
