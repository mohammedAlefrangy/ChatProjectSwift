//
//  ShowImagesVC.swift
//  Provider
//
//  Created by شموع صلاح الدين on 6/9/21.
//

import UIKit
//import SDWebImage

class ShowImagesVC: UIViewController {

    @IBOutlet weak var imageToShow: UIImageView!
    
    var imageStr = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
//        imageToShow.sd_setImage(with: URL(string: imageStr), completed: nil)
        
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
