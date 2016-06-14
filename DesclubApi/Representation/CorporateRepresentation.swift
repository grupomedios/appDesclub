//
//  CorporateRepresentation.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 14/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class CorporateRepresentation: Mappable {
	
	var _id: String?
	var name: String?
	var membershipPrefix: String?
	var created: NSDate?
	
	required init?(_ map: Map){
		
	}
	
	func mapping(map: Map) {
		_id <- map["_id"]
		name <- map["name"]
		membershipPrefix <- map["membershipPrefix"]
		created <- (map["created"], ISO8601DateTransform())
	}
	
}