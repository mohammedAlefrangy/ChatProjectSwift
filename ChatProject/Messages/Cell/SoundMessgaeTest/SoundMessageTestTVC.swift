//
//  SoundMessageTestTVC.swift
//  Provider
//
//  Created by شموع صلاح الدين on 5/3/21.
//

import UIKit
import AVFoundation

class SoundMessageTestTVC: UITableViewCell, AVAudioRecorderDelegate {
    
    @IBOutlet weak var messageContainerView: UIView!
    
    var audioPlayer = AVAudioPlayer()
    var toggleState = 1
    var url: URL?
    
    var updateTimer = Timer()
    var timer = Timer()
    
    let timerSpeed = 0.20
    
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playedTime: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sendTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageContainerView.layer.cornerRadius = 8
        messageContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func updateSlider() {
        slider.value = Float(audioPlayer.currentTime)
    }
    
    func startLoading() {
        playBtn.isHidden = true
        loading.startAnimating()
    }
    
    func stopLoading() {
        DispatchQueue.main.async { [self] in
            playBtn.isHidden = false
           }
        
        DispatchQueue.main.async { [self] in
            loading.stopAnimating()
           }
        
        
//        DispatchQueue.main.async { [self] in
//            loading.stopAnimating()
//        }
        
    }
    
    
    
    private var item: MessageData! {
        didSet{
            
            url = URL(string: item.mediaURL ?? "https://firebasestorage.googleapis.com:443/v0/b/lit-tracker-2b7a0.appspot.com/o/messageWithMedia336353628DD-5041-47B0-855A-29463E023AE0%2F8AA87DAC-ECBB-4FFC-834E-B3BDC53917D2.m4a?alt=media&token=39209b6c-c8c0-45da-9674-9be2b8338c4f")
//            playedTime.text = item.audioDuration
//            sendTimeLbl.text = item.sendTime
            
            print("data Sound \(url)")
        }
        
    }
    
    
    func configure(data: MessageData) {
        self.item = data
        
    }
    
    
    @IBAction func done(sender: AnyObject) {
        
        audioPlayer.stop()
    }
    
    var playingState = true
    
//    open func playSound(for message: MessageType, in audioCell: AudioMessageCell) {
//        switch message.kind {
//        case .audio(let item):
//            playingCell = audioCell
//            playingMessage = message
//            guard let player = try? AVAudioPlayer(contentsOf: item.url) else {
//                print("Failed to create audio player for URL: \(item.url)")
//                return
//            }
//            audioPlayer = player
//            audioPlayer?.prepareToPlay()
//            audioPlayer?.delegate = self
//            audioPlayer?.play()
//            state = .playing
//            audioCell.playButton.isSelected = true  // show pause button on audio cell
//            startProgressTimer()
//            audioCell.delegate?.didStartAudio(in: audioCell)
//        default:
//            print("BasicAudioPlayer failed play sound becasue given message kind is not Audio")
//        }
//    }
    
    
    @IBAction func play(sender: UIButton) {
        
        startLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            
            if playingState {
                startTimer()
              
                downloadFileFromURL(url: url! as NSURL)
               
                slider.maximumValue = Float(audioPlayer.duration)
                sender.setImage(UIImage(systemName: "stop.circle"), for: .normal)
            }else {
                stopLoading()
                stopTimer()
                updateTime()
                updateSlider()
                sender.setImage(UIImage(named:"ic-play"),for:.normal)
            }
            
            
        }
      
        playingState.toggle()
        
     
    }
   
    func startTimer() {
        updateTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        
    }
    
    func stopTimer() {
        updateTimer.invalidate()
        updateSlider()
        timer.invalidate()
        audioPlayer.stop()
        }
    
 
    
    func downloadFileFromURL(url:NSURL){
        //startLoading()
        
        if audioPlayer != nil && audioPlayer.isPlaying {
           
            stopTimer()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            var downloadTask:URLSessionDownloadTask
            downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
               
                guard let player = try? AVAudioPlayer(contentsOf: URL! as URL) else {
                    print("Failed to create audio player for URL: \(URL)")
                    return
                }
                
                self?.audioPlayer = player
                
                self?.audioPlayer.prepareToPlay()
                self?.audioPlayer.delegate = self
                self?.audioPlayer.play()
                
                
//                self?.play(url: URL! as NSURL)
                self?.stopLoading()
            })
            
            downloadTask.resume()
        }
        
    }
    
    
    @IBAction func pause(sender: AnyObject) {
        audioPlayer.pause()
        updateTime()
    }
    
    @IBAction func stop(sender: AnyObject) {
        audioPlayer.stop()
        updateTime()
    }
    @IBAction func scrubAudio(sender: AnyObject) {
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(slider.value)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    @objc func updateTime() {
        let currentTime = Int(audioPlayer.currentTime)
        let duration = Int(audioPlayer.duration)
        let total = currentTime - duration
        _ = String(total)
        
        let minutes = currentTime/60
        let seconds = currentTime - minutes / 60
        
        playedTime.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }
    
    
    
  
    
    
    func play(url:NSURL) {
          print("playing \(url)")
          
          do {
            _ = AVPlayerItem(url: url as URL)
              
            self.audioPlayer = try AVAudioPlayer(contentsOf: url as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
            audioPlayer.delegate = self
            audioPlayer.play()

          } catch let error as NSError {
              //self.player = nil
              print(error.localizedDescription)
          } catch {
              print("AVAudioPlayer init failed")
          }
          
      }
    
    
    
}



extension SoundMessageTestTVC: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayer.stop()
        playBtn.setImage(UIImage(named:"ic-play"),for:.normal)
       
    }
    


    open func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        audioPlayer.stop()
    }
}
