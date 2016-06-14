//
//  StateFacade.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 31/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class StateFacade:AbstractFacade {
	
	//singleton pattern for swift
	//check: http://code.martinrue.com/posts/the-singleton-pattern-in-swift
	
	class var sharedInstance: StateFacade {
		struct Static {
			static var instance: StateFacade?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = StateFacade()
		}
		
		return Static.instance!
	}
	
	/**
	get all states
	
	;param: viewController		the viewController
	:param: searchParams		the search parameters
	:param: completionHandler	the success handler
	:param: errorHandler		the error handler
	*/
	func getAllStates(viewController:UIViewController, searchParams:[String:String], completionHandler: ([StateRepresentation]?) -> Void, errorHandler: (ErrorType?) -> Void  ) -> () {
		
		request(StateRouter.getAllStates(parameters: searchParams))
			.validate()
			.responseArray{ (request, response, states: [StateRepresentation]?, raw:AnyObject?, error: ErrorType?) in

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