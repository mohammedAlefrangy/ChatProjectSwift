//
//  ReciverImageTVC.swift
//  Provider
//
//  Created by شموع صلاح الدين on 4/18/21.
//

import UIKit
import SDWebImage

class ReciverImageTVC: UITableViewCell {

    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageTimeLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
          messageContainerView.layer.cornerRadius = 8
          messageContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]

        
        messageImage.layer.cornerRadius = 8
        messageImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var item: MessageDataNewModel! {
        didSet{
            messageTimeLbl.text = item.date
            
            messageImage.sd_setImage(with: URL(string: item.mediaURL ?? ""), completed: nil)
        }
        
    }
    
    
    func configure(data: MessageDataNewModel) {
        self.item = data
    }
    
    
}
