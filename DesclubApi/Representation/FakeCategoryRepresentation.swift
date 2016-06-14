//
//  FakeCategoryRepresentation.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 23/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit
import Foundation

class FakeCategoryRepresentation:CategoryRepresentation {
	
	var image:String?
	var color:UIColor?
	
	required init?(_ map: Map) {
		super.init(map)
	}
	
	/**
	Initializes the object with predefined values
	
	:param: _id the category _id
	:param: name the category name
	:param: image the category image
	:param: color the category color
	*/
	init(_id:String, name:String, image:String, color:UIColor) {
		super.init(_id: _id, name: name)
		self.image = image
		self.color = color
	}
	
}