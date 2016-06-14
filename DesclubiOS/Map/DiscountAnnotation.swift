//
//  DiscountAnnotation.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 2/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation
import MapKit

class DiscountAnnotation: NSObject, MKAnnotation {
	
	@objc var coordinate: CLLocationCoordinate2D
	var title: String?
	var subtitle: String?
	
	var discount:DiscountRepresentation
	
	
	init(discount:NearByDiscountRepresentation){
		self.discount = discount.discount!
		if let branch = self.discount.branch {
			
			self.subtitle = branch.getCompleteAddress()
			
			if let branchName = branch.name {
				self.title = branchName
			}else{
				self.title = "Desclub"
			}

		}else{
			self.title = "Desclub"
			self.subtitle = ""
		}
		
		if let location = discount.discount?.location {
			if let coordinates = location.coordinates {
				let lat:Double = coordinates[1]
				let lon:Double = coordinates[0]
				self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude:  lon)
			}else{
				self.coordinate = CLLocationCoordinate2D(latitude: CommonConstants.defaultLatitude, longitude:  CommonConstants.defaultLongitude)
			}
		}else{
			self.coordinate = CLLocationCoordinate2D(latitude: CommonConstants.defaultLatitude, longitude:  CommonConstants.defaultLongitude)
		}
	}
	
}