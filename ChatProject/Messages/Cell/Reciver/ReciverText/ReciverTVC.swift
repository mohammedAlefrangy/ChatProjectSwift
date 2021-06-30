//
//  ReciverTVC.swift
//  Provider
//
//  Created by شموع صلاح الدين on 3/20/21.
//

import UIKit

class ReciverTVC: UITableViewCell {

    @IBOutlet weak var messageSendTimeLbl: UILabel!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var messageTextLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        messageContainerView.layer.cornerRadius = 8
        messageContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var item: MessageData! {
        didSet{
            messageTextLbl.text = item.textMessage
            messageSendTimeLbl.text = item.date
            
        }
        
    }
    
    
    func configure(data: MessageData) {
        self.item = data
    }
    
}
