//
//  SenderTVC.swift
//  Provider
//
//  Created by شموع صلاح الدين on 3/20/21.
//

import UIKit
//import SDWebImage


class SenderTVC: UITableViewCell {

    @IBOutlet weak var messageContainerView : UIView!
    @IBOutlet weak var messageTextLbl       : UILabel!
    @IBOutlet weak var messageTimeLbl       : UILabel!
    
    @IBOutlet weak var viewUnRead   : UIView!
    @IBOutlet weak var unReadLbl    : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        messageContainerView.layer.cornerRadius = 8
        messageContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private var item: MessageDataNewModel! {
        didSet{
            messageTextLbl.text = item.textMessage
            messageTimeLbl.text = item.date
            
        }
        
    }
    
    
    func configure(data: MessageDataNewModel) {
        self.item = data
    }
//    
    
}
