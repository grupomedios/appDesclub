//
//  DiscountRepresentation.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 25/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class DiscountRepresentation: Mappable {
	
	var _id: String?
	var branch: BranchRepresentation?
	var brand:BrandRepresentation?
	var subcategory: SubcategoryRepresentation?
	var category: CategoryRepresentation?
	
	var cash: String?
	var card: String?
	var promo: String?
	var restriction: String?
	
	var location: LocationRepresentation?
	
	
	required init?(_ map: Map){
		
	}
    
    func branchName() -> String?{
        if let branch = self.branch {
            if let name = branch.name {
                return name
            }
        }
        return nil
    }
	
	func mapping(map: Map) {
		_id <- map["_id"]
		branch <- map["branch"]
		brand <- map["brand"]
		subcategory <- map["subcategory"]
		category <- map["category"]
		cash <- map["cash"]
		card <- map["card"]
		promo <- map["promo"]
		restriction <- map["restriction"]
		location <- map["location"]
	}
	
}