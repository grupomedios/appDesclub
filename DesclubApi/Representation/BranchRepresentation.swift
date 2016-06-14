//
//  BranchRepresentation.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 25/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class BranchRepresentation: Mappable {
	
	var _id: String?
	var branchId: Int?
	var brand:String?
	var name: String?
	var street: String?
	var extNum: String?
	var intNum: String?
	var colony: String?
	var zipCode: String?
	var city: String?
	var state: String?
	var zone: String?
	var phone: String?
	var location: LocationRepresentation?
	
	required init?(_ map: Map){
		
	}
	
	func mapping(map: Map) {
		_id <- map["_id"]
		branchId <- map["branchId"]
		brand <- map["brand"]
		name <- map["name"]
		street <- map["street"]
		extNum <- map["extNum"]
		intNum <- map["intNum"]
		colony <- map["colony"]
		zipCode <- map["zipCode"]
		city <- map["city"]
		state <- map["state"]
		zone <- map["zone"]
		phone <- map["phone"]
		location <- map["location"]
	}
	
	func getCompleteAddress() -> String {
		
		var address = "" as String
		
		if let street = self.street {
			address = address + street
		}
		
		if let extNum = self.extNum {
			address = address + ", " + extNum
		}
		
		if let colony = self.colony {
			address = address + ", " + colony
		}
		
		if let city = self.city {
			address = address + ", " + city
		}
		
		return address
		
	}
	
}