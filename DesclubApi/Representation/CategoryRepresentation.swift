//
//  CategoryRepresentation.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 23/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class CategoryRepresentation: Mappable {
	
	var _id: String?
	var categoryId: Int?
	var originalName:String?
	var name: String?
	
	required init?(_ map: Map){
		
	}
	
	init(_id:String?, name:String){
		self._id = _id
		self.name = name
	}
	
	func mapping(map: Map) {
		_id <- map["_id"]
		categoryId <- map["categoryId"]
		originalName <- map["originalName"]
		name <- map["name"]
	}
	
}