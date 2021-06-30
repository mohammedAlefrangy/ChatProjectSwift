//
//  ReciverBillDetailsTVC.swift
//  Provider
//
//  Created by شموع صلاح الدين on 5/2/21.
//

import UIKit

class ReciverBillDetailsTVC: UITableViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var partsCountLbl: UILabel!
    @IBOutlet weak var sparePartTitleLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
//    private var item: SparePart! {
//        didSet{
//            
//            sparePartTitleLbl.text = item.sparePart
//            partsCountLbl.text = "x" + item.partsCount!.description
//            priceLbl.text = item.price?.description
//            
//            
//        }
//        
//    }
//    
//    
//    func configure(data: SparePart) {
//        self.item = data
//    }
    
    
}
