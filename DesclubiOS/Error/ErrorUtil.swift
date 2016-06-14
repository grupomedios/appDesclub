//
//  ErrorUtil.swift
//  BeepQuest
//
//  Created by Jhon Cruz on 20/03/15.
//  Copyright (c) 2015 GQuest. All rights reserved.
//

import Foundation
import UIKit

struct ErrorUtil {
	
	static func showAlert(title:String, message:String, viewController:UIViewController?){
		
		if let viewController = viewController {
				let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
				let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
				alert.addAction(defaultAction)
				
				viewController.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	static func createInvalidResponseError() -> NSError{
		return NSError(domain: "Invalid Response", code: 1234, userInfo: nil)
	}
	
}