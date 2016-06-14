//
//  AlertErrorHandler.swift
//  BeepQuest
//
//  Created by Jhon Cruz on 13/03/15.
//  Copyright (c) 2015 GQuest. All rights reserved.
//

import Foundation
import UIKit

struct AlertErrorHandler {
	
	/**
	Handles an error with an alert dialog
	
	:param: title				the dialog title
	:param:	message				the dialog message
	:param: uiViewController	the controller where the error has ocurred
	
	:returns: an error handler closure
	*/
	static func handleError(title:String, message:String, uiViewController:UIViewController) -> (error: NSError?) -> Void{
		
		/// error hander for login
		let errorHandler: (error: NSError?) -> Void = { (error:NSError?) in
			
			SwiftSpinner.hide()
			
			print(error)
			
			let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
			let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
			alert.addAction(defaultAction)
			uiViewController.presentViewController(alert, animated: true, completion: nil)
		}

		return errorHandler
	}
	
}