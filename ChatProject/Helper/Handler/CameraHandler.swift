//
//  CameraHandler.swift
//  ChatProject
//
//  Created by Mohammed on 6/24/21.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices

class CameraHandler: NSObject {
    static let shared = CameraHandler()
    
    private var currentVC: UIViewController!
    //MARK: Internal Properties
    var imagePickedBlock: ((UIImage,String) -> Void)?
    var videoPickedBlock: ((URL,UIImage) -> Void)?
    var filesPickedBlock: ((URL,String) -> Void)?
    
    func openImagePicker(_ source:UIImagePickerController.SourceType,_ types:[String] = [kUTTypeImage as String]){
        let picker = UIImagePickerController()
        picker.delegate = self;
        picker.sourceType = source
        picker.mediaTypes = types
        picker.allowsEditing = true
        picker.videoQuality = .typeMedium
        picker.videoMaximumDuration = 60
        picker.modalPresentationStyle = .custom
        currentVC.presentVC(picker)
    }

    func showActionSheet(_ vc: UIViewController,_ isVideo:Bool = false) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let action = UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                isVideo ? self.openImagePicker(.camera, [kUTTypeMovie as String, kUTTypeImage as String]) : self.openImagePicker(.camera)
            })
            actionSheet.addAction(action)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            actionSheet.addAction(UIAlertAction(title: "Gallery" , style: .default, handler: { (alert:UIAlertAction!) -> Void in
                isVideo ? self.openImagePicker(.photoLibrary, [kUTTypeMovie as String, kUTTypeImage as String]) : self.openImagePicker(.photoLibrary)
            }))
        }
        

        
        actionSheet.addAction(UIAlertAction(title: "Files" , style: .default, handler: { (alert:UIAlertAction!) -> Void in
            //            let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet, kUTTypePNG, kUTTypeXML, kUTTypeJPEG, kUTTypeFolder, kUTTypeArchive]
            let types = ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "com.microsoft.word.doc", "org.openxmlformats.spreadsheetml.sheet", "com.microsoft.excel.xls", "org.openxmlformats.wordprocessingml.document"]
            let documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            documentPicker.modalPresentationStyle = .overFullScreen
            vc.presentVC(documentPicker)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.modalPresentationStyle = .custom
        actionSheet.supportIpad(vc.view)
        vc.presentVC(actionSheet)
    }
    
    func showCameraPicker(_ vc: UIViewController) {
        currentVC = vc
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            self.openImagePicker(.camera,[kUTTypeImage as String,kUTTypeMovie as String])
        }
    }
    
    func showVideoPicker(_ vc: UIViewController) {
        currentVC = vc
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            self.openImagePicker(.photoLibrary,[kUTTypeMovie as String])
        }
    }
    
}

extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismissVC()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //
        if let url = info[.mediaURL] as? URL {
            if let thumb = MyTools.getThumbnailImage(url: url){
                videoPickedBlock?(url,thumb)
            }
            
            picker.dismissVC()
            return
        }
        
        var name = "IMG_\(MyTools.randomString(length: 4)).JPG"
        if let asset = info[.phAsset] as? PHAsset {
            if let _title = asset.value(forKey: "filename") as? String {
                name = _title
            }
        }
        
        if let image = info[.editedImage] as? UIImage {
            self.imagePickedBlock?(image,name)
        }else if let image = info[.originalImage] as? UIImage {
            self.imagePickedBlock?(image,name)
        }
        picker.dismissVC()
    }
}


extension CameraHandler: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard controller.documentPickerMode == .import, let url = urls.first else { return }
        
        print("The url for files is \(urls.first!.lastPathComponent) || \(url)")
        filesPickedBlock?(url,urls.first!.lastPathComponent)
        
        controller.dismiss(animated: true)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}

