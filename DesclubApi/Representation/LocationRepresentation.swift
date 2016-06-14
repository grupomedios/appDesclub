//
//  LocationRepresentation.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 25/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class LocationRepresentation: Mappable {
	
	var type:String?
	var coordinates: [Double]?
	
	required init?(_ map: Map){
		
	}
	
	func mapping(map: Map) {
		type <- map["type"]
		coordinates <- map["coordinates"]
	}
	
}