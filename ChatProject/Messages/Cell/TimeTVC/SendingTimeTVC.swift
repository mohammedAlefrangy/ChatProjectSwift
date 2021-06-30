//
//  SendingTimeTVC.swift
//  Provider
//
//  Created by شموع صلاح الدين on 3/20/21.
//

import UIKit

class SendingTimeTVC: UITableViewCell {

    @IBOutlet weak var dateTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
//    private var item: ChatOB! {
//        didSet{
//            dateTimeLbl.text = item.sendTime
//          print("dateTimeLbl.text \(dateTimeLbl.text)")
//            
//        }
//        
//    }
//    
//    
//    func configure(data: ChatOB) {
//        self.item = data
//    }
    
}
