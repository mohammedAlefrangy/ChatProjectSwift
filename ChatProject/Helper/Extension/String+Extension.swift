//
//  String+Extension.swift
//  ChatProject
//
//  Created by Mohammed on 6/20/21.
//

import Foundation
import UIKit

extension String {
    
    var toImage: UIImage {
        if self == "" {
            return UIImage()
        }else{
            let img = UIImage(named: self) ?? UIImage()
            return img
        }
    }
    
}
