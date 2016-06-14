//
//  ZoneFacade.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 1/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class ZoneFacade:AbstractFacade {
	
	//singleton pattern for swift
	//check: http://code.martinrue.com/posts/the-singleton-pattern-in-swift
	
	class var sharedInstance: ZoneFacade {
		struct Static {
			static var instance: ZoneFacade?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = ZoneFacade()
		}
		
		return Static.instance!
	}
	
	/**
	get all zones
	
	;param: viewController		the viewController
	:param: searchParams		the search parameters
	:param: completionHandler	the success handler
	:param: errorHandler		the error handler
	*/
	func getAllZones(viewController:UIViewController, searchParams:[String:String], completionHandler: ([ZoneRepresentation]?) -> Void, errorHandler: (ErrorType?) -> Void  ) -> () {
		
		request(ZoneRouter.getAllZones(parameters: searchParams))
			.validate()
			.responseArray{ (request, response, states: [ZoneRepresentation]?, raw:AnyObject?, error: ErrorType?) in
				
				if self.isValidResponse(response, viewController: viewController) {
					if error != nil {
						print(error)
						errorHandler(error)
					}else {
						completionHandler(states)
					}
				}else{
					errorHandler(ErrorUtil.createInvalidResponseError())
				}
		}
		
	}
	
}