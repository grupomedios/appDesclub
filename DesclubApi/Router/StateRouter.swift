//
//  StateRouter.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 31/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

enum StateRouter:URLRequestConvertible {
	
	case getAllStates(parameters:[String:AnyObject]?)
	
	var method:Method{
		
		switch self {
		case .getAllStates:
			return .GET
		}
		
	}
	
	var path:String {
		
		switch self {
		case .getAllStates(_):
			return Endpoints.states
		}
		
	}
	
	var URLRequest:NSMutableURLRequest {
		let URL = NSURL(string: Endpoints.baseURL)!
		let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
		mutableURLRequest.HTTPMethod = method.rawValue
		
		//set custom headers
		Endpoints.setCustomHeaders(mutableURLRequest)
		
		switch self {
			
		case .getAllStates(let parameters):
			return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
			
		}
		
	}
	
}