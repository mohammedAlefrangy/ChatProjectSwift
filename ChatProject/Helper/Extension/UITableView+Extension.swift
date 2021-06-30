//
//  UITableView+Extension.swift
//  ChatProject
//
//  Created by شموع صلاح الدين on 6/18/21.
//

import Foundation
import UIKit

extension UITableView {
    
    func scrollToBottom() {
        let lastSectionIndex = self.numberOfSections - 1
        if lastSectionIndex < 0 {
            return
        }
        
        
        let lastRowIndex = self.numberOfRows(inSection: lastSectionIndex) - 1
        if lastRowIndex < 0 {
            return
        }
        
        
        let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        self.scrollToRow(at: pathToLastRow, at: .bottom, animated: false)
        
    }
    
    func dequeueTVCell<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not locate viewcontroller with with identifier \(String(describing: T.self)) in storyboard.")
        }
        return cell
    }
    
    
    
    func layoutTableHeaderView() {
           
           guard let headerView = self.tableHeaderView else { return }
           headerView.translatesAutoresizingMaskIntoConstraints = false
           
           let headerWidth = headerView.bounds.size.width;
           let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[headerView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)), metrics: ["width": headerWidth], views: ["headerView": headerView])
           
           headerView.addConstraints(temporaryWidthConstraints)
           
           headerView.setNeedsLayout()
           headerView.layoutIfNeeded()
           
           let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
           let height = headerSize.height
           var frame = headerView.frame
           
           frame.size.height = height
           headerView.frame = frame
           
           self.tableHeaderView = headerView
           
           headerView.removeConstraints(temporaryWidthConstraints)
           headerView.translatesAutoresizingMaskIntoConstraints = true
           
       }
    
    
}
