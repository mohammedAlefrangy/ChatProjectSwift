//
//  SenderBillFooterTVC.swift
//  Provider
//
//  Created by شموع صلاح الدين on 5/1/21.
//

import UIKit

class SenderBillFooterTVC: UITableViewCell {

    @IBOutlet weak var vatLbl: UILabel!
    @IBOutlet weak var totalSparePartsLbl: UILabel!
    @IBOutlet weak var totalVatAmmountLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
//    private var item: SparePartsBillOB! {
//        didSet{
//            totalAmountLbl.text = item.calculations?.totalAmount
//            totalPriceLbl.text = item.calculations?.totalSparePartsAmount?.description
//            totalVatAmmountLbl.text = item.calculations?.totalVatAmount
//            totalSparePartsLbl.text = "x" + (item.calculations?.totalSpareParts!.description)!
//            vatLbl.text = "x" + (item.calculations?.vat!.description)!
//            
//        }
//        
//    }
//    
//    
//    func configure(data: SparePartsBillOB) {
//        self.item = data
//    }
    
    
}
