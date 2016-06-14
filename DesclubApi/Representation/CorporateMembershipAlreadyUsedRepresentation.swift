//
//  CorporateMembershipAlreadyUsedRepresentation.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 14/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation


class CorporateMembershipAlreadyUsedRepresentation: Mappable {
	
	var alreadyUsed: Bool?
	
	required init?(_ map: Map){
		
	}
	
	init(alreadyUsed:Bool){
		self.alreadyUsed = alreadyUsed
	}
	
	func mapping(map: Map) {
		alreadyUsed <- map["alreadyUsed"]
	}
	
}