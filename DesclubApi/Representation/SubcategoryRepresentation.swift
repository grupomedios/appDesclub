//
//  SubcategoryRepresentation.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 25/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class SubcategoryRepresentation: Mappable {
	
	var _id: String?
	var subcategoryId: Int?
	var name:String?
	var category: String?
	
	required init?(_ map: Map){
		
	}
	
	init(_id:String?, name:String){
		self._id = _id
		self.name = name
	}
	
	func mapping(map: Map) {
		_id <- map["_id"]
		subcategoryId <- map["subcategoryId"]
		name <- map["name"]
		category <- map["category"]
	}
	
}