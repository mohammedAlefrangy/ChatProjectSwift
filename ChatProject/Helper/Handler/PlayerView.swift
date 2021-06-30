//
//  PlayerView.swift
//  ChatProject
//
//  Created by Mohammed on 6/20/21.
//

import UIKit
import AVKit;
import AVFoundation;

class PlayerView: UIView {
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
    
}

//VideoTableViewCell
