//
//  DiscountRouter.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 25/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

enum DiscountRouter:URLRequestConvertible {
	
	case getAllNearByDiscounts(parameters:[String:AnyObject]?)
	case getAllDiscounts(parameters:[String:AnyObject]?)
	case getAllRecommendedDiscounts(parameters:[String:AnyObject]?)
	
	var method:Method{
		
		switch self {
		case .getAllNearByDiscounts:
			return .GET
		case .getAllDiscounts:
			return .GET
		case .getAllRecommendedDiscounts:
			return .GET
		}
		
	}
	
	var path:String {
		
		switch self {
		case .getAllNearByDiscounts(_):
			return Endpoints.nearByDiscounts
		case .getAllDiscounts(_):
			return Endpoints.discounts
		case .getAllRecommendedDiscounts(_):
			return Endpoints.recommendedDiscounts
		}
		
	}
	
	var URLRequest:NSMutableURLRequest {
        // 		let URL = NSURL(string: "http://feeds.grupomedios.com:6543")!
		let URL = NSURL(string: Endpoints.baseURL)!
		let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
		mutableURLRequest.HTTPMethod = method.rawValue
		
		//set custom headers
		Endpoints.setCustomHeaders(mutableURLRequest)
		
		switch self {
			
		case .getAllNearByDiscounts(let parameters):
			return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
		case .getAllDiscounts(let parameters):
			return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
		case .getAllRecommendedDiscounts(let parameters):
			return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
			
		}
		
	}
	
}