//
//  ReciverSoundMessageTVC.swift
//  Provider
//
//  Created by شموع صلاح الدين on 5/9/21.
//

import UIKit
import AVFoundation

class ReciverSoundMessageTVC: UITableViewCell, AVAudioRecorderDelegate {

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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @objc func updateSlider() {
        slider.value = Float(audioPlayer.currentTime)
    }
    
    func startLoading() {
        playBtn.isHidden = true
        loading.startAnimating()
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.playBtn.isHidden = false
           }
        
        DispatchQueue.main.async {
            self.loading.stopAnimating()
           }
        
    }
    
    private var item: MessageDataNewModel! {
        didSet{
            
            url = URL(string: "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.m4a")
//            playedTime.text = item.audioDuration
//            sendTimeLbl.text = item.sendTime
            
            print("data Sound \(url)")
        }
        
    }
    
    
    func configure(data: MessageDataNewModel) {
        self.item = data
        
    }
    
    
    @IBAction func done(sender: AnyObject) {
        
        audioPlayer.stop()
    }
    
    var playingState = true
    @IBAction func play(sender: UIButton) {
        
        startLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            
            if playingState {
                start1()
                downloadFileFromURL(url: url!)
                stopLoading()
                slider.maximumValue = Float(audioPlayer.duration)
                audioPlayer.play()
                updateTime()
                updateSlider()
                sender.setImage(UIImage(systemName: "stop.circle"), for: .normal)
            }else {
                stopLoading()
                stop1()
                updateTime()
                updateSlider()
                sender.setImage(UIImage(named:"ic-play"),for:.normal)
            }
            
            
        }
      
        playingState.toggle()
        
     
    }
   
    func start1() {
        updateTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        
    }
    
    func stop1() {
        updateTimer.invalidate()
        updateSlider()
        timer.invalidate()
        audioPlayer.stop()
        }
    
 
    
    func downloadFileFromURL(url:URL){
        startLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            var downloadTask:URLSessionDownloadTask
            downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
                self?.play(url: URL!)
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
    
    
    
    func play(url:URL) {
          print("playing \(url)")
          
          do {
            _ = AVPlayerItem(url: url as URL)
              
            self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: url.absoluteString))
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



extension ReciverSoundMessageTVC: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayer.stop()
        playBtn.setImage(UIImage(named:"ic-play"),for:.normal)
       
    }
}
