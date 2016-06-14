//
//  SilentErrorHandler.swift
//  BeepQuest
//
//  Created by Jhon Cruz on 24/03/15.
//  Copyright (c) 2015 GQuest. All rights reserved.
//

import Foundation

struct SilentErrorHandler {
	
	/**
	Handles an error silently
	
	:param: title				the dialog title
	:param:	message				the dialog message
	:param: uiViewController	the controller where the error has ocurred
	
	:returns: an error handler closure
	*/
	static func handleError() -> (error: NSError?) -> Void{
		
		/// error hander for login
		let errorHandler: (error: NSError?) -> Void = { (error:NSError?) in

			SwiftSpinner.hide()
			
			print(error)
		}
		
		return errorHandler
	}
	
}