//
//  CorporateMembershipFacade.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 14/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class CorporateMembershipFacade:AbstractFacade {
	
	//singleton pattern for swift
	//check: http://code.martinrue.com/posts/the-singleton-pattern-in-swift
	
	class var sharedInstance: CorporateMembershipFacade {
		struct Static {
			static var instance: CorporateMembershipFacade?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = CorporateMembershipFacade()
		}
		
		return Static.instance!
	}
	
	/**
	get corporate membership by number
	
	;param: viewController		the viewController
	:param: number				the membership number
	:param: completionHandler	the success handler
	:param: errorHandler		the error handler
	*/
	func getCorporateMembershipByNumber(viewController:UIViewController, number:String, completionHandler: (CorporateMembershipRepresentation?) -> Void, errorHandler: (ErrorType?) -> Void  ) -> () {
		
		request(CorporateMembershipRouter.getCorporateMembershipByNumber(number: number))
			.validate()
			.responseObject{ (request, response, states: CorporateMembershipRepresentation?, raw:AnyObject?, error: ErrorType?) in
				
				magic(raw)
				
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
	
	/**
	update corporate membership by number
	
	;param: viewController		the viewController
	:param: number				the membership number
	:param: email				the email
	:param: completionHandler	the success handler
	:param: errorHandler		the error handler
	*/
	func updateCorporateMembershipByNumber(viewController:UIViewController, number:String, email:String, completionHandler: (CorporateMembershipRepresentation?) -> Void, errorHandler: (ErrorType?) -> Void  ) -> () {
		
		request(CorporateMembershipRouter.updateCorporateMembershipByNumber(number: number, email:CorporateMembershipRepresentation(email: email)))
			.validate()
			.responseObject{ (request, response, states: CorporateMembershipRepresentation?, raw:AnyObject?, error: ErrorType?) in
				
				magic(raw)
				
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

	
	/**
	get corporate membership by id
	
	;param: viewController		the viewController
	:param: number				the membership number
	:param: completionHandler	the success handler
	:param: errorHandler		the error handler
	*/
	func changeCorporateMembershipStatus(viewController:UIViewController, membershipId:String, corporateMembershipAlreadyUsedRepresentation:CorporateMembershipAlreadyUsedRepresentation, completionHandler: (CorporateMembershipRepresentation?) -> Void, errorHandler: (ErrorType?) -> Void  ) -> () {
		
		request(CorporateMembershipRouter.changeCorporateMembershipStatus(id: membershipId, corporateMembershipAlreadyUsedRepresentation: corporateMembershipAlreadyUsedRepresentation))
			.validate()
			.responseObject{ (request, response, states: CorporateMembershipRepresentation?, raw:AnyObject?, error: ErrorType?) in
				
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