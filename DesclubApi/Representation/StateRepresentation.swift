//
//  StateRepresentation.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 31/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class StateRepresentation: Mappable {
	
	var _id: String?
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
		stateId <- map["stateId"]
		name <- map["name"]
	}
	
}