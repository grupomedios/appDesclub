//
//  SMImagePicker.swift
//  Coderix Solutions
//
//  Created by Sergio Maturano on 22/4/16.
//  Copyright © 2016 Sergio Maturano. All rights reserved.
//

import UIKit

class SMImagePicker: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    // MARK: - Public func.
    
    func imageSelected(img : UIImage) {
        // Should override this func in super class.
    }
    
    func showOptionsMenu() {
        
        let optionMenu = UIAlertController(title: nil, message: "Elegir opción", preferredStyle: .ActionSheet)
        
        let cameraOp = UIAlertAction(title: "Cámara", style: .Default, handler:{ (alert: UIAlertAction!) -> Void in
            self.showPicker(.Camera)
        })
        
        let libraryOp = UIAlertAction(title: "Galería", style: .Default, handler:{ (alert: UIAlertAction!) -> Void in
            self.showPicker(.PhotoLibrary)
        })
        
        let cancelOp = UIAlertAction(title: "Cancelar", style: .Cancel, handler:{ (alert: UIAlertAction!) -> Void in
        })
        
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            optionMenu.addAction(cameraOp)
        }
        
        optionMenu.addAction(libraryOp)
        optionMenu.addAction(cancelOp)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func showPicker(type : UIImagePickerControllerSourceType = .PhotoLibrary){
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = type
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Internals func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
     func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageSelected(pickedImage)
        }
        
        dismissViewControllerAnimated(true) { 
            self.closeImagePicker()
        }
    }
    
    func closeImagePicker() {
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}