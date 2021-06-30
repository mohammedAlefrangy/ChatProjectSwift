//
//  UIViewController+Extension.swift
//  ChatProject
//
//  Created by شموع صلاح الدين on 6/18/21.
//

import Foundation
import SystemConfiguration
import UIKit


extension UIViewController {
    
    
    func showToast(message: String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.numberOfLines = 0
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.4, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    //simple alert
    func showAlert(title: String, message:String, okAction: String = "Ok", completion: ((UIAlertAction) -> Void)? = nil ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okAction, style: .default, handler: completion))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithCancel(title: String, message:String, okAction: String = "Ok", completion: ((UIAlertAction) -> Void)? = nil ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okAction, style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertNoInternt() {
        showAlert(title: "", message: "No Internet Connection")
    }
    
    
    func addNotificationObserver(_ name: NSNotification.Name,_ selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    
    func postNotificationCenter(_ name: NSNotification.Name, _ object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object)
    }
    
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    
    
    func presentVC(_ vc:UIViewController,_ animated:Bool = true) {
        self.present(vc, animated: animated, completion: nil)
    }
    
    func presentModal(_ vc:UIViewController,_ animated:Bool = true) {
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: animated, completion: nil)
    }
    
    func presentCustom(_ vc:UIViewController,_ animated:Bool = true) {
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: animated, completion: nil)
    }
    
    func  pushManyVCs(_ vcs:[UIViewController],_ animated:Bool = true) {
        if let nav = navigationController {
            var nvcs = nav.viewControllers
            nvcs.append(contentsOf: vcs)
            nav.setViewControllers(nvcs, animated: true)
        }
    }
    
    func dismissVC(_ animated:Bool = true,_ completion: (() -> Void)? = nil) {
        self.dismiss(animated: animated, completion: completion)
    }
    
    func dismissNav(_ animated:Bool = true,_ completion: (() -> Void)? = nil) {
        self.navigationController?.dismiss(animated: animated, completion: completion)
    }
    
}


//MARK: alert controller
extension UIAlertController {

    func supportIpad(_ view:UIView){
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            // Ipad
            self.popoverPresentationController?.sourceView = view
            self.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        }
    }
    
}
