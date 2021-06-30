//
//  ReciverVideoMessageTVC.swift
//  ChatProject
//
//  Created by Mohammed on 6/30/21.
//

import UIKit
import AVKit
import AVFoundation

class ReciverVideoMessageTVC: UITableViewCell {

    @IBOutlet weak var messageTimeLbl: UILabel!
    @IBOutlet weak var playerView: PlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        playerView.layer.cornerRadius = 8
        playerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]

      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var item: MessageData! {
        didSet{
            let url = NSURL(string: item.mediaURL!);
            let avPlayer = AVPlayer(url: url as! URL);
            playerView?.playerLayer.player = avPlayer;
            playerView?.player?.play()
            messageTimeLbl.text = item.date
        }
        
    }
    
    
    func configure(data: MessageData) {
        self.item = data
    }
    
}
