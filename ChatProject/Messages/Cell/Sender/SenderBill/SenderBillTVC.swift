//
//  SenderBillTVC.swift
//  Provider
//
//  Created by شموع صلاح الدين on 5/1/21.
//

import UIKit

class SenderBillTVC: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var messageTimeLbl: UILabel!
    @IBOutlet weak var billDetails: UITableView!

//    var sparePartsBillOB: SparePartsBillOB?
//    var sparePart = [SparePart]()
    var sparePart = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        messageContainerView.layer.cornerRadius = 8
        messageContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        billDetails.delegate = self
        billDetails.dataSource = self

        billDetails.register(UINib(nibName: "SenderBillFooterTVC", bundle: nil), forCellReuseIdentifier: "SenderBillFooterTVC")

        billDetails.register(UINib(nibName: "SenderBillFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SenderBillFooterView")
        billDetails.register(UINib(nibName: "BillDetailsTVC", bundle: nil), forCellReuseIdentifier: "BillDetailsTVC")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
//    func updateCellWith(row: [SparePart]) {
//        self.sparePart = row
//        billDetails.reloadData()
//    }
//   
//    func updateBillWith(row: SparePartsBillOB) {
//        self.sparePartsBillOB = row
//        billDetails.reloadData()
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sparePart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillDetailsTVC", for: indexPath) as! BillDetailsTVC
        cell.selectionStyle = .none
        
        let item = sparePart[indexPath.row]
//        cell.configure(data: item)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cellFooter = tableView.dequeueReusableCell(withIdentifier: "SenderBillFooterTVC") as! SenderBillFooterTVC

//        let item = sparePartsBillOB
//        cellFooter.configure(data: item!)

        return cellFooter

    }
    
  
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 156
    }
}
