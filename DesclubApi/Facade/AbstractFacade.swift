//
//  AbstractFacade.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 25/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class AbstractFacade {
	
	func isValidResponse(response: NSHTTPURLResponse?, viewController:UIViewController) -> Bool{
		
		var isValid = true
		
		if let response = response {
			let statusCode = response.statusCode
			print("Status Code: \(statusCode)")
			
			//do something here when login exists
			
			
		}else{
			isValid = false
		}
		
		if !isValid {
			//ErrorUtil.showAlert("Error", message: "Error de conexión. Intente más tarde", viewController: viewController)
		}
		
		return isValid
		
	}
	
}