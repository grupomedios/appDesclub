//
//  CorporateMembershipRouter.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 14/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

enum CorporateMembershipRouter:URLRequestConvertible {
	
	case getCorporateMembershipByNumber(number:String)
	case updateCorporateMembershipByNumber(number:String, email:CorporateMembershipRepresentation)
	case changeCorporateMembershipStatus(id:String, corporateMembershipAlreadyUsedRepresentation:CorporateMembershipAlreadyUsedRepresentation)
	
	var method:Method{
		
		switch self {
		case .getCorporateMembershipByNumber:
			return .GET
		case .updateCorporateMembershipByNumber:
			return .PUT
		case .changeCorporateMembershipStatus:
			return .PUT
		}
		
	}
	
	var path:String {
		
		switch self {
		case .getCorporateMembershipByNumber(let number):
			return Endpoints.corporateMembershipsByNumber(number)
		case .updateCorporateMembershipByNumber(let params):
			return Endpoints.corporateMembershipsByNumber(params.number)
		case .changeCorporateMembershipStatus(let params):
			return Endpoints.corporateMembershipsById(params.id)
		}
		
	}
	
	var URLRequest:NSMutableURLRequest {
		let URL = NSURL(string: Endpoints.baseURL)!
		let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
		mutableURLRequest.HTTPMethod = method.rawValue
		
		//set custom headers
		Endpoints.setCustomHeaders(mutableURLRequest)
		
		switch self {
			
		case .updateCorporateMembershipByNumber(let params):
			return ParameterEncoding.JSON.encode(mutableURLRequest, parameters: Mapper().toJSON(params.email)).0
			
		case .changeCorporateMembershipStatus(let params):
			return ParameterEncoding.JSON.encode(mutableURLRequest, parameters: Mapper().toJSON(params.corporateMembershipAlreadyUsedRepresentation)).0
			
		default:
			return mutableURLRequest
			
		}
		
	}
	
}