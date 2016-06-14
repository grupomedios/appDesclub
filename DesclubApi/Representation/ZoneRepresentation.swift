//
//  ZoneRepresentation.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 1/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class ZoneRepresentation: Mappable {
	
	var _id: String?
	var zoneId: Int?
	var stateId: Int?
	var name: String?
	
	required init?(_ map: Map){
		
	}
	
	init(_id:String?, name:String){
		self._id = _id
		self.name = name
	}
	
	func mapping(map: Map) {
		_id <- map["_id"]
		zoneId <- map["zoneId"]
		stateId <- map["stateId"]
		name <- map["name"]
	}
	
}