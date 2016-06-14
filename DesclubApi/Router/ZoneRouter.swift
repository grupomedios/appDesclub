//
//  ZoneRouter.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 1/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

enum ZoneRouter:URLRequestConvertible {
	
	case getAllZones(parameters:[String:AnyObject]?)
	
	var method:Method{
		
		switch self {
		case .getAllZones:
			return .GET
		}
		
	}
	
	var path:String {
		
		switch self {
		case .getAllZones(_):
			return Endpoints.zones
		}
		
	}
	
	var URLRequest:NSMutableURLRequest {
		let URL = NSURL(string: Endpoints.baseURL)!
		let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
		mutableURLRequest.HTTPMethod = method.rawValue
		
		//set custom headers
		Endpoints.setCustomHeaders(mutableURLRequest)
		
		switch self {
			
		case .getAllZones(let parameters):
			return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
		}
		
	}
	
}