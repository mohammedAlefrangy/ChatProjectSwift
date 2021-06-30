//
//  MyTools.swift
//  ChatProject
//
//  Created by Mohammed on 6/24/21.
//

import UIKit
import AVKit

class MyTools: NSObject {
    
    static func getTimeOnly(_ date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    //MARK: Create group Chat Id
    static func createChatGroupId(userId:String,userId2:String) -> String {
        
        var chatRoomId = ""
        let comparison = userId.compare(userId2).rawValue
        
        if comparison < 0 {
            chatRoomId =  userId + "_" + userId2
        } else {
            chatRoomId = userId2 + "_" + userId
        }
        return chatRoomId
        
    }
    
    static func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    static func getDataFromUrl(url: URL, completion: @escaping ( _ data: Data?,_  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    static func getThumbnailImage(url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    static func openUrlBasic(urlStr:String) {
        if let url = URL(string: urlStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    static func jsonObject(_ object:Any) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return ""
        }
        return String(data: data, encoding: .utf8)!
    }
    
    static func jsonObjectData(_ object:Any) -> Data {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return Data()
        }
        return data//String(data: data, encoding: .utf8)!
    }
    
}
