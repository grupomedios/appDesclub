//
//  WarrantyStepsViewController.swift
//  DesclubiOS
//
//  Created by Sergio Maturano on 26/8/16.
//  Copyright © 2016 Grupo Medios. All rights reserved.
//

import Foundation
import MessageUI

class WarrantyStepsViewController: SMImagePicker, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var step1View: UIView!
    @IBOutlet weak var step2View: UIView!
    @IBOutlet weak var step3View: UIView!

    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var btnCall: UIButton!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStep1: UILabel!
    @IBOutlet weak var lblStep2: UILabel!
    @IBOutlet weak var lblStep3: UILabel!
    
    private var image : UIImage?
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configLayouts()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalitycUtil.trackScreenName("analytics.screen.request_warranty")
    }
    
    func configLayouts() {
        
        self.step1View.layer.cornerRadius = self.step1View.frame.size.width * 0.5
        self.step2View.layer.cornerRadius = self.step2View.frame.size.width * 0.5
        self.step3View.layer.cornerRadius = self.step3View.frame.size.width * 0.5
        
        self.btnScan.layer.cornerRadius = 10.0
        self.btnCall.layer.cornerRadius = 10.0
        
        let fontExtraBold = UIFont(name: "OpenSans-ExtraBold", size: 12.0)
        self.lblTitle.font = fontExtraBold
        self.btnScan.titleLabel?.font = fontExtraBold
        self.btnCall.titleLabel?.font = fontExtraBold
        
        let fontRegular = UIFont(name: "OpenSans-Regular", size: 16.0)
        self.lblStep1.font = fontRegular
        self.lblStep2.font = fontRegular
        self.lblStep3.font = fontRegular

    }
    
    //MARK: - Scan

    override func imageSelected(img : UIImage) {
        super.imageSelected(img)
        self.image = img
    }
    
    override func closeImagePicker() {
        if let img = self.image {
            self.openMailApp(img)
        }
    }
    
    func openMailApp(img : UIImage) {
        
        let emailTitle = "contact.subject".localized
        let toRecipents = ["contact.email".localized]
        let data = UIImageJPEGRepresentation(img, 0.5)!
        
        let membership:CorporateMembershipRepresentation = UserHelper.getCurrentUser()!
        let userName = membership.name!.uppercaseString
        let userEmail = membership.email!
        let userMember = UserHelper.getCardNumber()
        
        let messageBody = String.localizedStringWithFormat(NSLocalizedString("contact.body.format", comment: ""), "Desclub",userName, userEmail, userMember, UserHelper.getValidThru())
        
        if MFMailComposeViewController.canSendMail() {
            
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            mc.addAttachmentData(data, mimeType: "image/jpeg", fileName:  "image.jpeg")
            self.presentViewController(mc, animated: true, completion: nil)
            
        }else {
            
            self.showError("warranty.email_error")
        }
        
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        
        self.btnScan.backgroundColor = UIColor.grayColor()

        switch result {
        case MFMailComposeResultCancelled:
            print("Mail cancelled")
        case MFMailComposeResultSaved:
            print("Mail saved")
        case MFMailComposeResultSent:
            print("Mail sent")
        case MFMailComposeResultFailed:
            print("Mail sent failure")
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - IBActions
    
    @IBAction func closeWarranty(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func scanTicket(sender: AnyObject) {
        self.showOptionsMenu()
    }
    
    @IBAction func callSupport(sender: AnyObject) {
        
        let phoneNumber = 018008272582
        
        if let phoneCallURL:NSURL = NSURL(string: "telprompt://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }

    }
    
    //MARK: - Errors
    
    func showError(error : String?) {
        
        let alert = UIAlertController(title: "title_alert".localized, message: error?.localized, preferredStyle: .Alert)
        
        let okOp = UIAlertAction(title: "accept_alert".localized, style: .Default, handler:{ (alert: UIAlertAction!) -> Void in
        })
        
        alert.addAction(okOp)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}