//
//  CategoryRouter.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 1/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

enum CategoryRouter:URLRequestConvertible {
	
	case getAllCategories(parameters:[String:AnyObject]?)
	case getAllSubcategories(category:String, parameters:[String:AnyObject]?)
	
	var method:Method{
		
		switch self {
		case .getAllCategories:
			return .GET

		case .getAllSubcategories:
			return .GET
		}
		
	}
	
	var path:String {
		
		switch self {
		case .getAllCategories(_):
			return Endpoints.categories
		case .getAllSubcategories(let params):
			return Endpoints.subcategories(params.category)

		}
		
	}
	
	var URLRequest:NSMutableURLRequest {
		let URL = NSURL(string: Endpoints.baseURL)!
		let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
		mutableURLRequest.HTTPMethod = method.rawValue
		
		//set custom headers
		Endpoints.setCustomHeaders(mutableURLRequest)
		
		switch self {
			
		case .getAllCategories(let parameters):
			return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
		
		case .getAllSubcategories(let parameters):
			return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters.parameters).0
			
		}
		
	}
	
}