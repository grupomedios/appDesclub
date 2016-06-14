//
//  CategoryFacade.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 1/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class CategoryFacade:AbstractFacade {
	
	//singleton pattern for swift
	//check: http://code.martinrue.com/posts/the-singleton-pattern-in-swift
	
	class var sharedInstance: CategoryFacade {
		struct Static {
			static var instance: CategoryFacade?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = CategoryFacade()
		}
		
		return Static.instance!
	}
	
	/**
	get all categories
	
	;param: viewController		the viewController
	:param: searchParams		the search parameters
	:param: completionHandler	the success handler
	:param: errorHandler		the error handler
	*/
	func getAllCategories(viewController:UIViewController, searchParams:[String:String], completionHandler: ([CategoryRepresentation]?) -> Void, errorHandler: (ErrorType?) -> Void  ) -> () {
		
		request(CategoryRouter.getAllCategories(parameters: searchParams))
			.validate()
			.responseArray{ (request, response, states: [CategoryRepresentation]?, raw:AnyObject?, error: ErrorType?) in
				
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
	get all subcategories
	
	;param: viewController		the viewController
	;param: category			the category _id
	:param: searchParams		the search parameters
	:param: completionHandler	the success handler
	:param: errorHandler		the error handler
	*/
	func getAllSubcategories(viewController:UIViewController, category:String, searchParams:[String:String], completionHandler: ([SubcategoryRepresentation]?) -> Void, errorHandler: (ErrorType?) -> Void  ) -> () {
		
		request(CategoryRouter.getAllSubcategories(category: category, parameters: searchParams))
			.validate()
			.responseArray{ (request, response, states: [SubcategoryRepresentation]?, raw:AnyObject?, error: ErrorType?) in
				
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