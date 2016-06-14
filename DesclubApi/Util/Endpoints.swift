//
//  Endpoints.swift
//  BeepQuest
//
//  Created by Jhon Cruz on 11/03/15.
//  Copyright (c) 2015 GQuest. All rights reserved.
//

import Foundation

struct Endpoints {
	
	static let baseURL = NSBundle.mainBundle().objectForInfoDictionaryKey("BASE_URL") as! String
	
	// ------------- Discounts ---------------------
	static let nearByDiscounts = "/v1/desclubAPI/nearByDiscounts"
	static let discounts = "/v1/desclubAPI/discounts"
	static let recommendedDiscounts = "/v1/desclubAPI/recommendedDiscounts"
	
	// ------------- States ---------------------
	static let states = "/v1/desclubAPI/states"
	
	// ------------- Zones ---------------------
	static let zones = "/v1/desclubAPI/zones"
	
	// ------------- Categories ---------------------
	static let categories = "/v1/desclubAPI/categories"
	static func subcategories(category:String) -> String {
		return "/v1/desclubAPI/categories/\(category)/subcategories"
	}

	// ------------- Corporate Memberships ---------------------
	static func corporateMembershipsByNumber(number:String) -> String {
		return "/v1/desclubAPI/corporateMembershipsByNumber/\(number)"
	}
	static func corporateMembershipsById(id:String) -> String {
		return "/v1/desclubAPI/corporateMemberships/\(id)"
	}
	
	/**
	Set custom headers (token and user obtained from session, and other Desclub keys) to a URL request
	
	:param: mutableURLRequest	the URL request where the headers are being set to
	*/
	static func setCustomHeaders(mutableURLRequest: NSMutableURLRequest){
		
		
	}
	
}