//
//  NearByDiscountRepresentation.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 29/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class NearByDiscountRepresentation: Mappable {
	
	var dis: Double?
	var discount:DiscountRepresentation?
	
	required init?(_ map: Map){
		
	}
	
	init(discount:DiscountRepresentation){
		self.discount = discount
		self.dis = 0
	}
	
	func mapping(map: Map) {
		dis <- map["dis"]
		discount <- map["discount"]
	}
	
}