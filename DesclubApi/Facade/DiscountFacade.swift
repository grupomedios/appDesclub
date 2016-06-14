//
//  DiscountFacade.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 25/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class DiscountFacade:AbstractFacade {
	
	//singleton pattern for swift
	//check: http://code.martinrue.com/posts/the-singleton-pattern-in-swift
	
	class var sharedInstance: DiscountFacade {
		struct Static {
			static var instance: DiscountFacade?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = DiscountFacade()
		}
		
		return Static.instance!
	}
	
	/**
	get all nearBy discounts
	
	;param: viewController		the viewController
	:param: searchParams		the search parameters
	:param: completionHandler	the success handler
	:param: errorHandler		the error handler
	*/
	func getAllNearByDiscounts(viewController:UIViewController, searchParams:[String:String], completionHandler: ([NearByDiscountRepresentation]?) -> Void, errorHandler: (ErrorType?) -> Void  ) -> () {
		
		request(DiscountRouter.getAllNearByDiscounts(parameters: searchParams))
			.validate()
			.responseArray{ (request, response, discounts: [NearByDiscountRepresentation]?, raw:AnyObject?, error: ErrorType?) in
				
				magic(raw)
				
				if self.isValidResponse(response, viewController: viewController) {
					if error != nil {
						print(error)
						errorHandler(error)
					}else {
						completionHandler(discounts)
					}
				}else{
					errorHandler(ErrorUtil.createInvalidResponseError())
				}
		}
		
	}
	
	/**
	get all discounts
	
	;param: viewController		the viewController
	:param: searchParams		the search parameters
	:param: completionHandler	the success handler
	:param: errorHandler		the error handler
	*/
	func getAllDiscounts(viewController:UIViewController, searchParams:[String:String], completionHandler: ([DiscountRepresentation]?) -> Void, errorHandler: (ErrorType?) -> Void  ) -> () {
		
		request(DiscountRouter.getAllDiscounts(parameters: searchParams))
			.validate()
			.responseArray{ (request, response, discounts: [DiscountRepresentation]?, raw:AnyObject?, error: ErrorType?) in
				
				
				magic(raw)
				
				if self.isValidResponse(response, viewController: viewController) {
					if error != nil {
						print(error)
						errorHandler(error)
					}else {
						completionHandler(discounts)
					}
				}else{
					errorHandler(ErrorUtil.createInvalidResponseError())
				}
		}
		
	}
	
	
	/**
	get all recommended discounts
	
	;param: viewController		the viewController
	:param: searchParams		the search parameters
	:param: completionHandler	the success handler
	:param: errorHandler		the error handler
	*/
	func getAllRecommendedDiscounts(viewController:UIViewController, searchParams:[String:String], completionHandler: ([DiscountRepresentation]?) -> Void, errorHandler: (ErrorType?) -> Void  ) -> () {
		
		request(DiscountRouter.getAllRecommendedDiscounts(parameters: searchParams))
			.validate()
			.responseArray{ (request, response, discounts: [DiscountRepresentation]?, raw:AnyObject?, error: ErrorType?) in
				
				if self.isValidResponse(response, viewController: viewController) {
					if error != nil {
						print(error)
						errorHandler(error)
					}else {
						completionHandler(discounts)
					}
				}else{
					errorHandler(ErrorUtil.createInvalidResponseError())
				}
			}
		
	}
	
}