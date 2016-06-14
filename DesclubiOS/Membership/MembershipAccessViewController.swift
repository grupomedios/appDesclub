//
//  MembershipAccessViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 8/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit

class MembershipAccessViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet var commonView: UIView!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var lastName: UITextField!
	@IBOutlet weak var cardCode: UITextField!
	
	private var delegate:MembershipBaseUIViewController!
	
	
	init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, delegate:MembershipBaseUIViewController) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.delegate = delegate
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		//Looks for single or multiple taps.
		let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		commonView.addGestureRecognizer(tap)
		
		//move input if keyboard is shown
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
		
		self.email.delegate = self;
		self.cardCode.delegate = self;
    }

	@IBAction func closeModal(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	@IBAction func login(sender: UIButton) {
		
		SwiftSpinner.show("Autenticando", animated: true)
		
		let showValidationError:() -> Void = {
			let alertController = UIAlertController(title: "Error", message:
    "Tus credenciales no son válidas", preferredStyle: UIAlertControllerStyle.Alert)
			alertController.addAction(UIAlertAction(title: "Intentar de nuevo", style: UIAlertActionStyle.Default,handler: nil))
			
			self.presentViewController(alertController, animated: true, completion: nil)
		}
		
		let showValidationAlreadyUsedError:() -> Void = {
			let alertController = UIAlertController(title: "Membresía usada", message:
    "Esta membresía ya ha sido usada. Por favor contacte a soporte@desclub.com", preferredStyle: UIAlertControllerStyle.Alert)
			alertController.addAction(UIAlertAction(title: "Intentar de nuevo", style: UIAlertActionStyle.Default,handler: nil))
			
			self.presentViewController(alertController, animated: true, completion: nil)
		}
		
		/// completion handler for getCorporateMembershipByNumber
		let completionHandler: (membershipRepresentation:CorporateMembershipRepresentation?) -> Void = { (membershipRepresentation:CorporateMembershipRepresentation?) in
			
			SwiftSpinner.hide()
			
			if let membershipRepresentation = membershipRepresentation {
				magic(membershipRepresentation)
                /*
				if membershipRepresentation.lastName1?.lowercaseString == self.lastName.text?.lowercaseString {
					if membershipRepresentation.alreadyUsed != nil && !membershipRepresentation.alreadyUsed! {
						//success
						self.successfulMembership(membershipRepresentation)
					}else{
						showValidationAlreadyUsedError()
					}
				}else{
					showValidationError()
				}*/
                self.successfulMembership(membershipRepresentation)
			}else{
				showValidationError()
			}
		}
		
		let errorHandler: (error: ErrorType?) -> Void = { (error:ErrorType?) in
			SwiftSpinner.hide()
			showValidationError()
		}
		
		CorporateMembershipFacade.sharedInstance.getCorporateMembershipByNumber(self, number: cardCode.text!, completionHandler: completionHandler, errorHandler: errorHandler)
		
	}
	
	private func successfulMembership (membershipRepresentation: CorporateMembershipRepresentation) {
		
		/// completion handler for getCorporateMembershipByNumber
		let completionHandler: (membershipRepresentation:CorporateMembershipRepresentation?) -> Void = { (membershipRepresentation:CorporateMembershipRepresentation?) in
		
			if let membershipRepresentation = membershipRepresentation {
				UserHelper.setCurrentUser(membershipRepresentation)
			}
			
			self.dismissViewControllerAnimated(true, completion: nil)
			
			self.delegate.afterLogin()
			
			let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
			appDelegate.tabBarController.selectedIndex = 3
			
			
			//update email if provided
			if(self.email.text!.characters.count > 0){
				
				let silentCompletionHandler: (membershipRepresentation:CorporateMembershipRepresentation?) -> Void = {_ in
				}
				
				let silentErrorHandler: (error: ErrorType?) -> Void = { (error:ErrorType?) in
				}
				
				CorporateMembershipFacade.sharedInstance.updateCorporateMembershipByNumber(self, number: self.cardCode.text!, email: self.email.text!, completionHandler: silentCompletionHandler, errorHandler: silentErrorHandler)
			}
			
		}
		
		let errorHandler: (error: ErrorType?) -> Void = { (error:ErrorType?) in
			SwiftSpinner.hide()
		}
		
		let alreadyUsed:CorporateMembershipAlreadyUsedRepresentation = CorporateMembershipAlreadyUsedRepresentation(alreadyUsed: true)
		
		CorporateMembershipFacade.sharedInstance.changeCorporateMembershipStatus(self, membershipId: membershipRepresentation._id!, corporateMembershipAlreadyUsedRepresentation:alreadyUsed,  completionHandler: completionHandler, errorHandler: errorHandler)
		
	}
	
	func keyboardWillShow(sender: NSNotification) {
		self.view.frame.origin.y = -100
	}
	func keyboardWillHide(sender: NSNotification) {
		self.view.frame.origin.y = 0
	}
	
	//Calls this function when the tap is recognized.
	func dismissKeyboard(){
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		commonView.endEditing(true)
		self.view.frame.origin.y = 0
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	

}
