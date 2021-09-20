//
//  StartVC.swift
//  ChatProject
//
//  Created by Mohammed on 8/18/21.
//

import UIKit
import Firebase

class StartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func startChatBtn(_ sender: Any) {
        func_startChat(chatRoomId: 336, Sender_Id: "103")
        
        // MARK: Write-review for app in app store
//      // 1.
//        let productURL = URL(string: "https://itunes.apple.com/app/id1564056562")
//        var components = URLComponents(url: productURL!, resolvingAgainstBaseURL: false)
//
//        // 2.
//        components?.queryItems = [
//          URLQueryItem(name: "action", value: "write-review")
//        ]
//
//        // 3.
//        guard let writeReviewURL = components?.url else {
//          return
//        }
//
//        // 4.
//        UIApplication.shared.open(writeReviewURL)
        
    }
    
    
    func func_startChat(chatRoomId:Int, Sender_Id:String){
        
//        guard let root = topViewController() else {return}
        Constant.UserNodes.child(Sender_Id).observeSingleEvent(of: .value) { (snapshot) in
//            root.hideIndicator()
            if snapshot.exists() {
                let user  = UserNewModel(snapshot: snapshot)
//                let chatVC : ChatViewController = AppDelegate.AppSB.instanceVC()
                let chatVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                chatVC.senderId             =  Sender_Id // change 1 to self.userId \(Auth_User.User_Id)
                chatVC.senderDisplayName    =  "Mohammed Ahmed" //"\(Auth_User.UserInfo.name)"
                chatVC.chatRoomId           =  String(chatRoomId)
                chatVC.reciverInfo          =  user
                self.navigationController?.pushViewController(chatVC, animated: true)
//                root.pushNavVC(chatVC)
            }else {
                print("UserNoAvailable")
//                root.showOkAlert(title: "", message: Constant.UserNoAvailable)
            }
        }
        
    }
}
