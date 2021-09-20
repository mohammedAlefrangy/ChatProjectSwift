//
//  MessageVC.swift
//  Provider
//
//  Created by شموع صلاح الدين on 3/20/21.
//


import UIKit
//import SVProgressHUD
import AVFoundation
//import IQAudioRecorderController
//import Alamofire
import YPImagePicker
import Firebase


class MessageVC: UIViewController {
    
    @IBOutlet weak var lbAudioTimer                 : UILabel!
    @IBOutlet weak var ivAudioMic                   : UIImageView!
    @IBOutlet weak var sendButtonWidthConstraint    : NSLayoutConstraint!
    @IBOutlet weak var sendButtonHeightConstraint   : NSLayoutConstraint!
    @IBOutlet weak var sendButtonTrailingConstraint : NSLayoutConstraint!
    @IBOutlet var      sendButtonLongPressGesture   : UILongPressGestureRecognizer!
    @IBOutlet var      sendButtonPanGesture         : UIPanGestureRecognizer!
    @IBOutlet weak var slideToCancelView            : UIStackView!
    @IBOutlet weak var tableView                    : UITableView!
    @IBOutlet weak var messageTF                    : UITextField!
    @IBOutlet weak var sendButton                   : UIButton!
    @IBOutlet weak var viewAudioTimer               : UIView!
    @IBOutlet weak var lblTyping                    : UILabel!
    @IBOutlet weak var lbl_status                   : UILabel!
    @IBOutlet weak var lbl_title                    : UILabel!
    
    var fromAccpectOffer    = false
    var isUser              = false
    var audioDuration       = ""
    //    var orderOffersOB: OrderOB?
    //    var sparePartsBillOB: SparePartsBillOB?
    
    
    var offerID         = 0
    //    var chatArray = [ChatOB]()
    var chatArray       = [String]()
    var attachedImage   : UIImage?
    var voicePathStr    = ""
    
    //    var recordingSession: AVAudioSession!
    //    var audioRecorder: AVAudioRecorder!
    var voiceFileData: Data?
    var titleMessage = ""
    
    private var audioDurationInSecs = 0
    private var audioTimer: Timer?
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var audioFilename = ""
    private var audioPlayer: AVPlayer!
    
    //FireBase
    private var fetchingData    : DatabaseReference!
    private var FirstFetch      : DatabaseHandle?
    private var isTypingHandle  : DatabaseHandle?
    private var userIsTypingRef : DatabaseReference!
    private var userIsActive    : DatabaseReference!
    private var isActiveHandle  : DatabaseHandle?
    
    private var myUserId = "51a33729856d4d3792b6a19a50048bcf"
    var messages = [MessageDataNewModel]()
    private var isReciverActive : Bool = true
    private var fisrt_unseen_messgaesId : String = ""
    
    private var count = 0
    var pageSize = 20
    let preloadMargin = 5
    var lastLoadedPage = 0
    var insertCounter = 0
    
    // From perviesous VC
    var senderId            : String!
    var chatRoomId          : String!
    var senderDisplayName   : String!
    var reciverInfo         : UserNewModel!
    var adminID = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        reciverInfo.UserId
        messageTF.delegate = self
        
        if self.adminID == String(Constant.Admin_Id) {
            self.lbl_title.text = "LIT"
            self.setOnlineStatus()
        }else {
            self.lbl_title.text = "LIT"
        }
        
        CountOfMessages()
        typingObserver()
        observeTypingUser()
        
        sendButtonLongPressGesture.delegate = self
        let mensagem = messageTF.text ?? ""
        if mensagem.isEmpty {
            sendButtonLongPressGesture.isEnabled = true
            sendButtonPanGesture.isEnabled = true
        } else {
            sendButtonLongPressGesture.isEnabled = false
            sendButtonPanGesture.isEnabled = false
        }
        
        
        initTableView()
        
        // Get Chat From Server
        self.fetchMessages()
        
        sendButtonLongPressGesture.delegate = self
        
        if self.count > 20 {
            tableView.tableHeaderView?.isHidden = false
        }else {
            tableView.tableHeaderView?.isHidden = true
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        //        self.setNavigationBarHidden(false)
        
        Constant.DBRefrence.child(Constant.Seen).child(self.chatRoomId).child(senderId).setValue(["counter":0])
        self.func_setUserAcive(true)
        
        if  reciverInfo.UserId != String(Constant.Admin_Id) {
            observeIsActive()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        //        self.setNavigationBarHidden()
        self.func_setUserAcive(false)
        //        IQKeyboardManager.shared.enable = true
        self.func_removeObserver()
        self.func_removeObservers()
        //        did_home_load = false
    }
    
    //    func func_userDataChangeOBserver(){
    //
    //        self.checkUserChangedValue = Constant.DBRefrence.child(Constant.UserNode)
    //            .child(self.reciverInfo.UserId)
    //        checkUserChangedValueHandel =   self.checkUserChangedValue.observe(.value) { (snapshot) in
    //            let user = User(snapshot: snapshot)
    //            self.reciverInfo = user
    //        }
    //    }
    
    func func_removeObservers(){
        if  isActiveHandle != nil
        {
            userIsActive.removeObserver(withHandle: isActiveHandle!)
        }
        if  isTypingHandle != nil
        {
            userIsTypingRef.removeObserver(withHandle: isTypingHandle!)
        }
        
        if  FirstFetch != nil
        {
            fetchingData.removeObserver(withHandle: FirstFetch!)
        }
        //
        //        if  checkUserChangedValueHandel != nil
        //        {
        //            checkUserChangedValue.removeObserver(withHandle: checkUserChangedValueHandel!)
        //        }
        
        self.func_setUserAcive(false)
    }
    
    func typingObserver(){
        
        let typeRef = Constant.DBRefrence.child(Constant.chatRoomsNode)
            .child(self.chatRoomId)
            .child(Constant.TypeIndicator)
            .child(senderId)
        typeRef.setValue(["TypeStatus":false])
    }
    
    fileprivate func observeTypingUser(){
        self.userIsTypingRef = Constant.DBRefrence.child(Constant.chatRoomsNode)
            .child(self.chatRoomId)
            .child(Constant.TypeIndicator)
            .child(self.adminID)
        
        isTypingHandle = self.userIsTypingRef.observe(.childChanged, with: { (snapshot) in
            
            if snapshot.value as! Bool {
                self.lblTyping.isHidden = false
                self.tableView.scrollToBottom()
            }else {
                self.lblTyping.isHidden = true
            }
        })
    }
    
    @IBAction func didTapLoadEarlierMessagesButton(_ sender: Any) {
        self.pageSize = self.pageSize + 20
        self.LoadMore(Size: self.pageSize)
    }
}

// MARK: - ***** Action Button { Send Button && Attach file or photo } ***** -
extension MessageVC {
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        //Send New Message Request
        
        if !self.isConnectedToNetwork(){
            self.showAlertNoInternt()
            return
        }
        
        if messageTF.text == "" {
            return
        }
        
        let messageRefSender = Constant.DBRefrence.child(Constant.chatRoomsNode)
            .child(self.chatRoomId)
            .child(Constant.messages)
            .childByAutoId()
        
        let status = self.isReciverActive ? 1 : 0
        //        let user = Auth_User.UserInfo
        let  message = MessageNewModel(Message: messageTF.text!,
                               SenderUid: senderId,
                               Sendername: "MohammedAhmed",
                               SenderImage:  "MyImage",
                               ReceiverUid: self.reciverInfo.UserId,
                               Receivername: self.reciverInfo.FullName,
                               ReceiverImage: self.reciverInfo.UserImage,
                               Timestamp: 23/06/2021 ,
                               GroupId: chatRoomId,
                               mediaType: "text",
                               status : status,
                               mediaUrl: "")
        
        
        messageRefSender.setValue(message.toAnyObject()) { (error, ref) in
            if error == nil
            {
                
                //                JSQSystemSoundPlayer.jsq_playMessageSentSound()
                print("Constant.DBRefrence \(Constant.DBRefrence)")
                Constant.DBRefrence.child(Constant.chatRoomsNode)
                    .child(self.chatRoomId)
                    .child(Constant.TypeIndicator)
                    .child(self.senderId)
                    .child(Constant.TypeStatus)
                    .setValue(false)
                
                Constant.DBRefrence.child(Constant.RecentNode)
                    .child(self.chatRoomId)
                    .setValue(message.toAnyObject())
                ////
                if !self.isReciverActive{
                    let unSeenMessage = Constant.DBRefrence.child(Constant.Seen)
                        .child(self.chatRoomId)
                        .child(self.adminID)
                    
                    
                    unSeenMessage.child("counter").observeSingleEvent(of: .value, with: { (snapshot) in
                        var countNum : Int = 1
                        if snapshot.exists()
                        {
                            countNum = 1 + (snapshot.value as! Int)
                        }
                        unSeenMessage.setValue(["counter":countNum])
                    })
                    
                    //                    self.sendChatNotification()
                    //                    MyApi.api.sendPushNotification(user_id: self.reciverInfo.UserId)
                }
            }
        }
        
        
        messageTF.text = ""
        tableView.scrollToBottom()
    }
    
    @IBAction func actionAttachBtn(_ sender: Any) {
        
        CameraHandler.shared.showActionSheet(self, true)
        CameraHandler.shared.videoPickedBlock = { video, name in
            self.saveMediaMessage(withImage: nil, withVideo: video)
            
        }
        CameraHandler.shared.imagePickedBlock = { img, name in
            self.saveMediaMessage(withImage: img, withVideo: nil)
        }
        CameraHandler.shared.filesPickedBlock = { url, name in
            self.saveFilesMessage(withFiles: url, name: name)
        }
    }
    
}

// MARK: - ***** FetchMessages Method ***** -
extension MessageVC {
    
    func fetchMessages(){
        self.fetchingData = Constant.DBRefrence.child(Constant.chatRoomsNode)
            .child(self.chatRoomId)
            .child(Constant.messages)
        
        self.FirstFetch = self.fetchingData.queryLimited(toLast: 20).observe(.childAdded, with: { (snapshot) in
            let msg = MessageNewModel(snapshot: snapshot)
            let cDate = Date(timeIntervalSince1970: TimeInterval(msg.Timestamp))
            
            self.chatArray.append(snapshot.key)
            
            if msg.SenderUid != "\(self.senderId)" &&  msg.status == 0 {
                if self.fisrt_unseen_messgaesId == "" {
                    self.fisrt_unseen_messgaesId = snapshot.key
                }
                
                Constant.DBRefrence.child(Constant.chatRoomsNode)
                    .child(self.chatRoomId)
                    .child(Constant.messages)
                    .child(snapshot.key).updateChildValues(["status":1])
            }
            
            print("msg.mediaType \(msg.mediaType)")
            switch msg.mediaType {
            case "text":
                //replcae name not used with message id
                let msg = MessageDataNewModel(senderID: msg.SenderUid, senderName: snapshot.key, date: "20/06/2021", textMessage: msg.Message, messageType: .text)
                self.messages.append(msg)
                
            case "image":
                //                let photo = MessageData(Photo: "chat_placeholder".toImage, messageType: .photo)
                let mss = MessageDataNewModel(senderID: msg.SenderUid, senderName: msg.Sendername, date: "20/6/2021", Photo: "chat_placeholder".toImage, mediaURL: msg.mediaUrl, messageType: .photo)
                self.messages.append(mss)
                
            case "video":
                let mss = MessageDataNewModel(senderID: msg.SenderUid, senderName: msg.Sendername, date: "20/6/2021", Photo: "chat_placeholder".toImage, mediaURL: msg.mediaUrl, messageType: .video)
                self.messages.append(mss)
                
                break
                
            case "file":
                let msg = MessageDataNewModel(senderID: msg.SenderUid, senderName: snapshot.key, date: "20/06/2021", textMessage: msg.Message, urlFile: msg.mediaUrl, messageType: .text)
                self.messages.append(msg)
                
            case "sound":
                let msg = MessageDataNewModel(senderID: msg.SenderUid, senderName: snapshot.key, date: "20/06/2021", textMessage: msg.Message, urlFile: msg.mediaUrl, messageType: .sound)
                self.messages.append(msg)
                
                break
                
            default: break
            }
            
            self.tableView.reloadData()
            self.tableView.scrollToBottom()
            if self.pageSize <= self.messages.count {
                self.tableView.tableHeaderView?.isHidden = false
            } else {
                self.tableView.tableHeaderView?.isHidden = true
            }
        })
    }
    
}

// MARK: - ***** Load More FetchMessages ***** -
extension MessageVC {
    
    //MARK: Load more
    func LoadMore(Size:Int) {
        self.messages.removeAll()
//        self.allMessagesId.removeAll()
        let messageQuery = Constant.DBRefrence.child(Constant.chatRoomsNode)
            .child(chatRoomId).child(Constant.messages)
            .queryLimited(toLast: UInt(Size))
        
        messageQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            for snap in snapshot.children {
                let msg = MessageNewModel(snapshot: snap as! DataSnapshot)

                let cDate = Date(timeIntervalSince1970: TimeInterval(msg.Timestamp))
                
//                self.allMessagesId.append(snapshot.key)
                print("msg.mediaType \(msg.mediaType)")
                switch msg.mediaType {
                case "text":
                    //replcae name not used with message id
                    let msg = MessageDataNewModel(senderID: msg.SenderUid, senderName: snapshot.key, date: "20/06/2021", textMessage: msg.Message, messageType: .text)
                    self.messages.append(msg)
                    
                case "image":
                    //                let photo = MessageData(Photo: "chat_placeholder".toImage, messageType: .photo)
                    let mss = MessageDataNewModel(senderID: msg.SenderUid, senderName: msg.Sendername, date: "20/6/2021", Photo: "chat_placeholder".toImage, mediaURL: msg.mediaUrl, messageType: .photo)
                    self.messages.append(mss)
                    
                case "video":
                    let mss = MessageDataNewModel(senderID: msg.SenderUid, senderName: msg.Sendername, date: "20/6/2021", Photo: "chat_placeholder".toImage, mediaURL: msg.mediaUrl, messageType: .video)
                    self.messages.append(mss)
                    
                    break
                    
                case "file":
                    let msg = MessageDataNewModel(senderID: msg.SenderUid, senderName: snapshot.key, date: "20/06/2021", textMessage: msg.Message, urlFile: msg.mediaUrl, messageType: .text)
                    self.messages.append(msg)
                    
                case "sound":
                    let msg = MessageDataNewModel(senderID: msg.SenderUid, senderName: snapshot.key, date: "20/06/2021", textMessage: msg.Message, urlFile: msg.mediaUrl, messageType: .sound)
                    self.messages.append(msg)
                    
                    break
                    
                default: break
                }
                
                self.tableView.reloadData()
//                self.tableView.scrollToBottom()
                if self.pageSize <= self.messages.count {
                    self.tableView.tableHeaderView?.isHidden = false
                } else {
                    self.tableView.tableHeaderView?.isHidden = true
                }
                
            }
        })
        
    }
    
    func CountOfMessages() {
        let messageQuery = Constant.DBRefrence.child(Constant.chatRoomsNode)
            .child(chatRoomId)
            .child(Constant.messages)
        
        messageQuery.observe(.value) { (snapshot) in
            self.count =  Int(snapshot.childrenCount)
        }
    }
  
}

// MARK: - ***** Save data to FireBase { Files, Media and Image } ***** -
extension MessageVC {
    
    private func saveFilesMessage(withFiles url: URL?, name: String?){
        
        if let urlPath = url {
            
            let filePath = "Files/\(name!)"
            let fileRef = Constant.StorageRef.child(filePath)
            let metadata = StorageMetadata()
            metadata.contentType = "file"
            
            //            self.showIndicator()
            
            fileRef.putFile(from: urlPath, metadata: metadata, completion: { (newMetaData, error) in
                
                guard error == nil else {
                    //                    self.showToast("Error when upload file".localized)
                    //                    self.hideIndicator()
                    return
                }
                
                fileRef.downloadURL(completion: { (url, error) in
                    
                    guard error == nil else {
                        //                        self.showToast("Error when upload image".localized)
                        //                        self.hideIndicator()
                        return
                    }
                    print("The url from fireBase \(url?.absoluteURL)")
                    self.func_saveImageToFirebase(url?.absoluteString ?? "", message: name!, mediaType: "file")
                })
                
            })
        }
    }
    
    private func saveMediaMessage(withImage image: UIImage?, withVideo url: URL?){
        
        if let image = image {
            let imagePath = "messageWithMedia\(self.chatRoomId + UUID().uuidString)/photo.jpg"
            let imageRef = Constant.StorageRef.child(imagePath)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let imageData = image.jpegData(compressionQuality: 0.8)
            //            self.showIndicator()
            
            imageRef.putData(imageData!, metadata: metadata, completion: { (newMetaData, error) in
                
                guard error == nil else {
                    //                    self.showToast("Error when upload image".localized)
                    //                    self.hideIndicator()
                    return
                }
                
                imageRef.downloadURL(completion: { (url, error) in
                    
                    guard error == nil else {
                        //                        self.showToast("Error when upload image".localized)
                        //                        self.hideIndicator()
                        return
                    }
                    print(url?.absoluteURL ?? "")
                    self.func_saveImageToFirebase(url?.absoluteString ?? "", message: "image", mediaType: "image")
                })
                
            })
        }
        
        else {
            let videoPath = "messageWithMedia\(self.chatRoomId + UUID().uuidString)/\(audioFilename).mov"
            let videoRef = Constant.StorageRef.child(videoPath)
            let metadata = StorageMetadata()
            metadata.contentType = "video/mov"
            
            videoRef.putFile(from: url!, metadata: metadata, completion: { (newMetaData, error) in
                
                guard error == nil else {
                    print(error ?? "Error when upload sound")
                    //                    self.showToast("Error when upload image".localized)
                    //                    self.hideIndicator()
                    return
                }
                
                videoRef.downloadURL(completion: { (url, error) in
                    
                    guard error == nil else {
                        print(error ?? "Error when upload video")
                        //                        self.showToast("Error when upload image".localized)
                        //                        self.hideIndicator()
                        return
                    }
                    print(url?.absoluteURL ?? "")
                    self.func_saveImageToFirebase(url?.absoluteString ?? "", message: "video", mediaType: "video")
                })
                
            })
            
        }
        
    }
    
    private func func_saveImageToFirebase(_ urlStr:String,message: String ,mediaType:String) {
        let messageRefSender = Constant.DBRefrence.child(Constant.chatRoomsNode)
            .child(self.chatRoomId)
            .child(Constant.messages)
            .childByAutoId()
        let status = self.isReciverActive ? 1 : 0
        //        let user = Auth_User.UserInfo
        
        
        let  message = MessageNewModel(Message: message,
                               SenderUid: senderId,
                               Sendername: "MohammedAhmed",
                               SenderImage:  "MyImage",
                               ReceiverUid: self.reciverInfo.UserId,
                               Receivername: self.reciverInfo.FullName,
                               ReceiverImage: self.reciverInfo.UserImage,
                               Timestamp: 24/06/2021 ,
                               GroupId: self.chatRoomId,
                               mediaType: mediaType,
                               status : status,
                               mediaUrl: urlStr)
        
        
        messageRefSender.setValue(message.toAnyObject()) { (error, ref) in
            //            self.hideIndicator()
            if error == nil{
                
                Constant.DBRefrence.child(Constant.chatRoomsNode)
                    .child(self.chatRoomId)
                    .child(Constant.TypeIndicator)
                    .child(self.senderId)
                    .child(Constant.TypeStatus)
                    .setValue(false)
                
                Constant.DBRefrence.child(Constant.RecentNode)
                    .child(self.chatRoomId)
                    .setValue(message.toAnyObject())
                
                ////
                //                if !self.isReciverActive{
                //
                //                    let unSeenMessage = Constant.DBRefrence.child(Constant.Seen)
                //                        .child(self.chatRoomId)
                //                        .child(self.reciverInfo.UserId)
                //
                //
                //                    unSeenMessage.child("counter").observeSingleEvent(of: .value, with: { (snapshot) in
                //                        var countNum : Int = 1
                //                        if snapshot.exists()
                //                        {
                //                            countNum = 1 + (snapshot.value as! Int)
                //                        }
                //                        unSeenMessage.setValue(["counter":countNum])
                //                    })
                //                    //                    self.finishSendingMessage()
                self.tableView.scrollToBottom()
                self.tableView.reloadData()
                //                }
            }
        }
    }
}

// MARK: - ***** Set Online or Offline user status ***** -
extension MessageVC {
    
    fileprivate func observeIsActive() {
        
        self.userIsActive = Constant.DBRefrence.child(Constant.chatRoomsNode)
            .child(self.chatRoomId).child(Constant.Active).child(String(String(Constant.Admin_Id)))
        isActiveHandle = self.userIsActive.observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                let value = snapshot.value as! [String:Any]
                let status = value["Active"] as! Bool
                self.isReciverActive = status
                switch status {
                case false :
                    self.self.setOfflineStatus()
                default:
                    self.setOnlineStatus()
                }
            }else {
                self.setOfflineStatus()
            }
        })
    }
    
    func setOnlineStatus(){
        lbl_status.text = "ONLINE"
        lbl_status.textColor = "00ABA3".color
        //        btn_status.backgroundColor = "00ABA3".color
    }
    
    func setOfflineStatus(){
        lbl_status.text = "OFFLINE"
        lbl_status.textColor = "8AA0B7".color
        //        btn_status.backgroundColor = "8AA0B7".color
    }
    
    //MARK: check app status
    func func_checkAppStatus(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(func_setOffline), name: UIApplication.willResignActiveNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(func_setOnline), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func func_removeObserver(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func func_setOffline() {
        self.func_setUserAcive(false)
    }
    
    @objc func func_setOnline() {
        Constant.DBRefrence.child(Constant.Seen).child(self.chatRoomId).child(senderId).setValue(["counter":0])
        self.func_setUserAcive(true)
    }
    
    func func_setUserAcive(_ active:Bool){
        Constant.DBRefrence.child(Constant.chatRoomsNode)
            .child(self.chatRoomId)
            .child("Active")
            .child(senderId)
            .setValue(["Active":active])
    }
    
}

// MARK: - ***** Send button long press gesture delegate ***** -
extension MessageVC : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (gestureRecognizer == sendButtonLongPressGesture && otherGestureRecognizer == sendButtonPanGesture)
    }
}

// MARK: - ***** Audio recorder delegate ***** -
extension MessageVC : AVAudioRecorderDelegate {
    
    private func updateInterface(recording: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if recording {
                self.sendButtonWidthConstraint.constant = 45
                self.sendButtonHeightConstraint.constant = 45
                self.view.layoutIfNeeded()
                self.sendButton.layer.cornerRadius = 22.5
            } else {
                self.sendButtonWidthConstraint.constant = 35
                self.sendButtonHeightConstraint.constant = 35
                self.view.layoutIfNeeded()
                self.sendButton.layer.cornerRadius = 17.5
            }
            
            self.viewAudioTimer.isHidden = !recording
            self.slideToCancelView.isHidden = !recording
            
            self.messageTF.isHidden = recording
        })
    }
    
    @IBAction private func sendButtonLongPress(_ sender: UILongPressGestureRecognizer) {
        
        
        // Setting up AudioSession
        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission {}
        }
        
        
        
        
        if sender.state == .began { // Send button is being pressed, start recording
            
            print("sendButtonLongPress ... began")
            updateInterface(recording: true)
            startAudioTimer()
            startRecording()
        } else if sender.state == .ended { // Send button was released, stop recording
            print("sendButtonLongPress ... ended")
            updateInterface(recording: false)
            stopRecording()
            sendAudio()
            stopAudioTimer()
        } else if sender.state == .cancelled { // Send button long press gesture was cancelled, cancel recording
            print("sendButtonLongPress ... cancelled")
            stopAudioTimer()
            cancelRecording()
            updateInterface(recording: false)
        }
    }
    
    @IBAction private func sendButtonPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        // Enable pan gesture only if the send button is being pressed
        if sender.view != nil && sendButtonLongPressGesture.state == .changed {
            let current = sendButtonTrailingConstraint.constant - translation.x // En. Lang.
            sendButtonTrailingConstraint.constant = translation.x +  sendButtonTrailingConstraint.constant // Ar. Lang.
            
            let percentage = 100 * (current / self.view.frame.width)
            
            if percentage > 30 {
                stopAudioTimer()
            }
        }
        
        sender.setTranslation(.zero, in: self.view)
    }
    
    private func stopAudioTimer() {
        if audioTimer != nil {
            sendButtonLongPressGesture.isEnabled = false
            sendButtonPanGesture.isEnabled = false
            
            UIView.animate(withDuration: 1, animations: {
                self.sendButtonTrailingConstraint.constant = 5
            })
            
            audioTimer?.invalidate()
            audioDurationInSecs = 0
            lbAudioTimer.text = "0:00"
            audioTimer = nil
            
            sendButtonPanGesture.isEnabled = true
            sendButtonLongPressGesture.isEnabled = true
        }
    }
    
    private func startAudioTimer() {
        audioTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateAudioTimer),
            userInfo: nil,
            repeats: true)
    }
    
    @objc private func updateAudioTimer() {
        audioDurationInSecs += 1
        let minutes = Int(floor(Double(audioDurationInSecs / 60)))
        
        UIView.animate(withDuration: 0.3) {
            let alpha = self.ivAudioMic.alpha
            
            self.ivAudioMic.alpha = alpha == 0 ? 1 : 0
        }
        
        lbAudioTimer.text = "\(minutes):\(String(format: "%02d", audioDurationInSecs % 60))"
        audioDuration = lbAudioTimer.text!
        
        //Send with parameter: audioDurationInSecs
        //Show it to User: lbAudioTimer.text = "\(minutes):\(String(format: "%02d", audioDurationInSecs % 60))"
        print("Duration \(audioDuration)")
    }
    
    private func startRecording() {
        
        
        if audioRecorder == nil {
            audioFilename = UUID().uuidString
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentDirectory = paths[0]
            let filename = documentDirectory.appendingPathComponent("\(audioFilename).m4a")
            print("Recording audio = \(filename)")
            print("Recording audio = \(documentDirectory)")
            print("Recording audio = \(paths)")
            sendButton.isHidden = true
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue]
            
            do {
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                
                let recording = audioRecorder.record()
                print("Recording audio = \(recording)")
            } catch {
                print(error)
            }
        }
    }
    
    private func stopRecording() {
        print("Stopped recording...")
        audioRecorder.stop()
        audioRecorder = nil
        sendButton.isHidden = false
    }
    
    private func cancelRecording() {
        stopRecording()
        sendButton.isHidden = false
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let url = documentDirectory.appendingPathComponent("\(audioFilename).m4a")
        
        do {
            print("Removing audio -> \(audioFilename).m4a")
            try FileManager.default.removeItem(at: url)
        } catch {
            print(error)
        }
    }
    
    private func sendAudio() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let audio = documentDirectory.appendingPathComponent("\(audioFilename).m4a")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            print("Recording audio = 123 \(audio.absoluteString)")
            self.saveMediaMessage(withImage: nil, withVideo: audio)
            //            self.toUploadVoiceFile(filePathAudio: audio)
        }
    }
    
    private func hideUnReadText(){
        self.fisrt_unseen_messgaesId = ""
        tableView.reloadData()
    }
}

// MARK: - ***** TableView delegate ***** -
extension MessageVC: UITableViewDelegate, UITableViewDataSource {
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ReciverImageTVC", bundle: nil), forCellReuseIdentifier: "ReciverImageTVC")
        tableView.register(UINib(nibName: "SenderImageTVC", bundle: nil), forCellReuseIdentifier: "SenderImageTVC")
        
        tableView.register(UINib(nibName: "ReciverTVC", bundle: nil), forCellReuseIdentifier: "ReciverTVC")
        tableView.register(UINib(nibName: "SenderTVC", bundle: nil), forCellReuseIdentifier: "SenderTVC")
        
        tableView.register(UINib(nibName: "SendingTimeTVC", bundle: nil), forCellReuseIdentifier: "SendingTimeTVC")
        
        tableView.register(UINib(nibName: "ReciverSoundMessageTVC", bundle: nil), forCellReuseIdentifier: "ReciverSoundMessageTVC")
        tableView.register(UINib(nibName: "SoundMessageTestTVC", bundle: nil), forCellReuseIdentifier: "SoundMessageTestTVC")
        
        tableView.register(UINib(nibName: "VideoMessageTVC", bundle: nil), forCellReuseIdentifier: "VideoMessageTVC")
        tableView.register(UINib(nibName: "ReciverVideoMessageTVC", bundle: nil), forCellReuseIdentifier: "ReciverVideoMessageTVC")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = messages[indexPath.row]
        
        
        switch item.messageType {
        case .text:
            if item.senderID != senderId {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTVC", for: indexPath) as! SenderTVC
                cell.selectionStyle = .none
                
                if item.senderName == self.fisrt_unseen_messgaesId {
                    cell.unReadLbl.isHidden = false
                    cell.unReadLbl.text = "UnRead"
                    cell.viewUnRead.isHidden = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        self.hideUnReadText()
                    }
                } else{
                    cell.unReadLbl.isHidden = true
                    cell.viewUnRead.isHidden = true
                }
                
                cell.configure(data: item)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReciverTVC", for: indexPath) as! ReciverTVC
                cell.selectionStyle = .none
                cell.configure(data: item)
                return cell
            }
            
        case .photo:
            if item.senderID != senderId{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderImageTVC", for: indexPath) as! SenderImageTVC
                cell.selectionStyle = .none
                if item.senderName == self.fisrt_unseen_messgaesId {
                    cell.unReadLbl.isHidden = false
                    cell.unReadLbl.text = "UnRead"
                    cell.viewUnRead.isHidden = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        self.hideUnReadText()
                    }
                } else{
                    cell.unReadLbl.isHidden = true
                    cell.viewUnRead.isHidden = true
                }
                cell.configure(data: item)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReciverImageTVC", for: indexPath) as! ReciverImageTVC
                cell.selectionStyle = .none
                cell.configure(data: item)
                return cell
                
            }
            
        case .video:
            if item.senderID != senderId {
                let cell = tableView.dequeueReusableCell(withIdentifier: "VideoMessageTVC", for: indexPath) as! VideoMessageTVC
                cell.selectionStyle = .none
                if item.senderName == self.fisrt_unseen_messgaesId {
                    cell.unReadLbl.isHidden = false
                    cell.unReadLbl.text = "UnRead"
                    cell.viewUnRead.isHidden = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        self.hideUnReadText()
                    }
                } else{
                    cell.unReadLbl.isHidden = true
                    cell.viewUnRead.isHidden = true
                }
                cell.configure(data: item)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReciverVideoMessageTVC", for: indexPath) as! ReciverVideoMessageTVC
                cell.selectionStyle = .none
                cell.configure(data: item)
                return cell
            }
            
        case .file:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SendingTimeTVC", for: indexPath) as! SendingTimeTVC
            cell.selectionStyle = .none
            //            cell.configure(data: item)
            return cell
            
        case .sound:
            if item.senderID != senderId{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SoundMessageTestTVC", for: indexPath) as! SoundMessageTestTVC
                cell.selectionStyle = .none
                cell.configure(data: item)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReciverSoundMessageTVC", for: indexPath) as! ReciverSoundMessageTVC
                cell.selectionStyle = .none
                cell.configure(data: item)
                return cell
                
            }
            
        case .None:
            break
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SendingTimeTVC", for: indexPath) as! SendingTimeTVC
            cell.selectionStyle = .none
            //            cell.configure(data: item)
            return cell
        }
        
        
        
        /*
         if item.type == 0 {
         let cell = tableView.dequeueReusableCell(withIdentifier: "SendingTimeTVC", for: indexPath) as! SendingTimeTVC
         cell.selectionStyle = .none
         cell.configure(data: item)
         return cell
         }
         
         switch item.userType {
         case 1: // User : Sender
         
         switch item.type {
         
         
         
         
         case 2:// Image
         
         
         
         case 3:
         
         
         case 4:
         
         
         
         default:
         break
         }
         
         case 2: // Provider : Receiver
         
         switch item.type {
         
         case 1: // Text
         
         
         
         case 2:// Image
         
         
         
         case 3:
         
         
         
         case 4:
         
         
         default:
         break
         }
         
         break
         default:
         break
         }
         */
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let item = chatArray[indexPath.row]
        /*
         switch item.userType {
         case 1: // User : Sender
         
         switch item.type {
         
         case 1: // Text
         break
         
         //ShowImagesVC
         
         case 2:// Image
         
         let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowImagesVC") as! ShowImagesVC
         
         vc.imageStr = item.image ?? ""
         vc.modalPresentationStyle = .overCurrentContext
         vc.modalTransitionStyle = .crossDissolve
         
         self.present(vc, animated: true, completion: nil)
         
         case 3:
         break
         case 4:
         break
         default:
         break
         }
         
         case 2: // Provider : Receiver
         
         switch item.type {
         
         case 1: // Text
         break
         
         case 2:// Image
         
         let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowImagesVC") as! ShowImagesVC
         
         vc.imageStr = item.image ?? ""
         vc.modalPresentationStyle = .overCurrentContext
         vc.modalTransitionStyle = .crossDissolve
         
         self.present(vc, animated: true, completion: nil)
         
         
         case 3:
         break
         case 4:
         break
         default:
         break
         }
         
         break
         default:
         break
         }
         */
    }
}

// MARK: - ***** ImagePicker delegate ***** -
extension MessageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBAction func selectPhotoToUpload(_ sender: UIButton) {
        selectPhoto()
        //        let picker = UIImagePickerController()
        //        picker.sourceType = .photoLibrary
        //        picker.allowsEditing = true
        //        picker.delegate = self
        //
        //        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    func selectPhoto() {
        
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    
                    self.showAlertWithCancel(title: "", message: "هل أنت متأكد من اختيار هذه الصورة", okAction: "أجل") { [self] (alert) in
                        attachedImage = photo.image
                        
                        //                        send New Message Image From User
                    }
                    
                }
                
                
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else{
            return
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            self.showAlertWithCancel(title: "", message: "هل أنت متأكد من اختيار هذه الصورة", okAction: "أجل") { [self] (alert) in
                attachedImage = image
                
                
                //                send New Message Image From Provider
            }
            
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ***** API Request ***** -
extension MessageVC {
}

// MARK: - ***** TextFieldDelegate to check if user typing or not ***** -
extension MessageVC :UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        Constant.DBRefrence.child(Constant.chatRoomsNode)
            .child(chatRoomId)
            .child(Constant.TypeIndicator)
            .child(senderId)
            .child(Constant.TypeStatus).setValue(true)
        
//        if textField.text!.count > 0 {
//            Constant.DBRefrence.child(Constant.chatRoomsNode)
//                .child(chatRoomId)
//                .child(Constant.TypeIndicator)
//                .child(senderId)
//                .child(Constant.TypeStatus).setValue(true)
//
//        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        Constant.DBRefrence.child(Constant.chatRoomsNode)
            .child(chatRoomId)
            .child(Constant.TypeIndicator)
            .child(senderId)
            .child(Constant.TypeStatus)
            .setValue(false)
    }
    
}

//#warning("T##message##")
//#error("Nothing")
//// MARK: - ***** Nothing ***** -
//// Fixme:
