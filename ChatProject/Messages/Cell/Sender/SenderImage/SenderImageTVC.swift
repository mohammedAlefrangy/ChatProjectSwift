//
//  SenderImageTVC.swift
//  Provider
//
//  Created by شموع صلاح الدين on 4/18/21.
//

import UIKit
import SDWebImage

class SenderImageTVC: UITableViewCell {

    @IBOutlet weak var messageContainerView : UIView!
    @IBOutlet weak var senderMessageTimeLbl : UILabel!
    @IBOutlet weak var senderImageMessage   : UIImageView!
    
    @IBOutlet weak var viewUnRead : UIView!
    @IBOutlet weak var unReadLbl  : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
        messageContainerView.layer.cornerRadius = 8
        messageContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]

        
        senderImageMessage.layer.cornerRadius = 8
        senderImageMessage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
  
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    private var item: MessageData! {
        didSet{
            senderImageMessage.sd_setImage(with: URL(string: item.mediaURL ?? ""), completed: nil)
            senderMessageTimeLbl.text = item.date

        }

    }


    func configure(data: MessageData) {
        self.item = data
    }
    
}
