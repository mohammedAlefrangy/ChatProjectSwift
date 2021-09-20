//
//  User.swift
//  ChatProject
//
//  Created by Mohammed on 8/18/21.
//

import Foundation
import Firebase

struct UserNewModel {
    
    var UserId: String
    var UserImage : String = ""
    var FullName : String
    var DeviceToken: String
    var Status : Int
    var OS : String
    
    
    init(UserId:String, UserImage: String, FullName: String, DeviceToken:String)
    {
        self.UserId  = UserId
        self.UserImage = UserImage
        self.FullName = FullName
        self.DeviceToken = DeviceToken
        self.Status = 1
        self.OS = "iOS"
    }
    
    init(snapshot:Any)
    {
        let snap = snapshot as! DataSnapshot
        let snapshotValue = snap.value as! NSDictionary
        
        self.UserId = snap.key
        self.UserImage = snapshotValue["userImage"] as? String ?? ""
        self.FullName = snapshotValue["userFullName"] as? String ?? ""
        self.DeviceToken = snapshotValue["deviceToken"] as? String ?? ""
        self.Status = snapshotValue["status"] as? Int ?? 1
        self.OS = snapshotValue["userOs"] as? String ?? ""
        
    }
    
    init()
    {
        self.UserId = ""
        self.UserImage = ""
        self.FullName = ""
        self.DeviceToken = ""
        self.Status = 1
        self.OS = ""
    }
    
    func toAnyObject() -> Any
    {
        return
            [
                "myIdMember"     : self.UserId,
                "userImage"      : self.UserImage,
                "userFullName"   : self.FullName,
                "deviceToken"    : self.DeviceToken,
                "status"         : self.Status,
                "userOs"         : self.OS
            ]
    }
}
