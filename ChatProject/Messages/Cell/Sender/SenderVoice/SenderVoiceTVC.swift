//
//  SenderVoiceTVC.swift
//  Provider
//
//  Created by شموع صلاح الدين on 4/18/21.
//

import UIKit

import AVKit


class SenderVoiceTVC: UITableViewCell {
    
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var soundTrack: UIView!
    @IBOutlet weak var playSoundBtn: UIButton!
    @IBOutlet weak var messageTimeLbl: UILabel!
    @IBOutlet weak var soundDurationLbl: UILabel!
    
    var EQtimer1 = Timer()
    let timerSpeed = 0.20
    
    var player: AVAudioPlayer?
    var url: URL?
    
    var numberOfBars = 14
    var barWidth = CGFloat(10)
    var barHeight = CGFloat(20)
    var barSpace = CGFloat(2)
    var barStopHeight = CGFloat(2)
//    let barColor = "00A69C".color
    
    var barArray: [AnyObject] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        messageContainerView.layer.cornerRadius = 8
        messageContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        
        // Create temp object array
        var tempArray: [AnyObject] = []
        
        // Create bar UIImageView
        for i in 0...numberOfBars - 1 {
            let myImage = UIImageView()
            if i == 0 {
                myImage.frame = CGRect(x: 0, y: 0, width: barWidth, height: barStopHeight)
            } else {
                myImage.frame = CGRect(x: (CGFloat(barSpace) * CGFloat(i)) + (CGFloat(barWidth) * CGFloat(i)) , y: 0, width: barWidth, height: barStopHeight)//  * CGFloat(-1)
            }
//            myImage.backgroundColor = barColor
            myImage.tag = 50 + i
            soundTrack.addSubview(myImage)
            tempArray.append(myImage)
        }
        
        barArray = tempArray
        
        soundTrack.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2) * CGFloat(2.0))
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
//    private var item: ChatOB! {
//        didSet{
//            soundDurationLbl.text = ""
//            messageTimeLbl.text = item.sendTime
//            
//            url = URL(string: item.audio ?? "")
//        }
//        
//    }
//    
//    
//    func configure(data: ChatOB) {
//        self.item = data
//    }
    
    
    func start1() {
        EQtimer1 = Timer.scheduledTimer(timeInterval: timerSpeed, target: self, selector: #selector(ticker1), userInfo: nil, repeats: true)
    }
    
    @objc func ticker1() {
           let tempX = barWidth + barSpace
           var i = 50
           var j = 0
           UIView.animate(withDuration: 0.35, animations: { [self] () -> Void in
               for bar in self.barArray  {
                   let tempButton = soundTrack.viewWithTag(i)
                       
                       
                       //viewCon!.view.viewWithTag(i)
                   var rect = bar.frame
                   rect?.origin.x = CGFloat(j) * CGFloat(tempX)
                   rect?.origin.y = CGFloat(0)
                   rect?.size.width = CGFloat(self.barWidth)
                   rect?.size.height = CGFloat(arc4random_uniform(UInt32(self.barHeight)))
                   tempButton!.frame = rect!
                   i = i + 1
                   j += 1
               }
           })
       }
    
   
    var playingState = true
    
    @IBAction func playSoundMsg(_ sender: UIButton) {
         
          if playingState {
             
//            playSouncIcon.image = UIImage(named: "ic-StopNoFill")
//            playSouncIcon.tintColor = .white
            
            
              start1()
              downloadFileFromURL(url: url! as NSURL)
              
          }else {
              
//            playSouncIcon.image = UIImage(named: "ic-PlaySound")

              stop1()
              
          }
          
          playingState.toggle()
          
        
      }
    func downloadFileFromURL(url:NSURL){

          var downloadTask:URLSessionDownloadTask
          downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
              self?.play(url: URL as! NSURL)
          })
              
          downloadTask.resume()
          
      }
    
    func play(url:NSURL) {
          print("playing \(url)")
          
          do {
              let playerItem = AVPlayerItem(url: url as URL)
              
              self.player = try AVAudioPlayer(contentsOf: url as URL)
              player!.prepareToPlay()
              player!.volume = 1.0
              player!.delegate = self
              player!.play()

          } catch let error as NSError {
              //self.player = nil
              print(error.localizedDescription)
          } catch {
              print("AVAudioPlayer init failed")
          }
          
      }
    
    func stop1() {
//        playSouncIcon.image = UIImage(named: "ic-PlaySound")
          EQtimer1.invalidate()
          player?.stop()
       
          let tempX = barWidth + barSpace
          var i = 50
          var j = 0
          UIView.animate(withDuration: 0.35, animations: { [self] () -> Void in
              for bar in self.barArray  {
                  let tempButton = soundTrack.viewWithTag(i)
                  var rect = bar.frame
                  rect?.origin.x = CGFloat(j) * CGFloat(tempX)
                  rect?.origin.y = CGFloat(0)
                  rect?.size.width = CGFloat(self.barWidth)
                  rect?.size.height = self.barStopHeight
                  tempButton!.frame = rect!
                  i = i + 1
                  j += 1
              }
          })
          
      }
     
    
    
}



extension SenderVoiceTVC: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop1()
    }
    
    

    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        print("audioPlayerBeginInterruption \(player)")
    }
}
