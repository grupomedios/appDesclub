//
//  BrandRepresentation.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 25/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class BrandRepresentation: Mappable {
	
	var _id: String?
	var brandId: Int?
	var name: String?
	var logoSmall: String?
	var logoBig: String?
	var validity_start: NSDate?
	var validity_end: NSDate?
	var url: String?
	
	
	required init?(_ map: Map){
		
	}
	
	func mapping(map: Map) {
		_id <- map["_id"]
		brandId <- map["brandId"]
		name <- map["name"]
		logoSmall <- map["logoSmall"]
		logoBig <- map["logoBig"]
		validity_start <- (map["validity_start"], ISO8601DateTransform())
		validity_end <- (map["validity_end"], ISO8601DateTransform())
		url <- map["url"]
	}
	
}