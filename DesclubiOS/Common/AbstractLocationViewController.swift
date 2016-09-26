//
//  AbstractLocationViewController.swift
//  BeepQuest
//
//  Created by Jhon Cruz on 29/07/15.
//  Copyright (c) 2015 GQuest. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth


class AbstractLocationViewController: UIViewController, CLLocationManagerDelegate {
	
	private var locationManager:CLLocationManager = CLLocationManager()
	
	var currentLocation: CLLocation!
	
	
	override func viewDidAppear(animated: Bool) {
		
		super.viewDidAppear(animated)
		setUpLocation()
	}
	
	/**
	sets up the location
	*/
	func setUpLocation(){
		//location
        
		locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
		self.locationManager.delegate = self
		self.locationManager.pausesLocationUpdatesAutomatically = false
		
		if(self.locationManager.respondsToSelector(#selector(CLLocationManager.requestAlwaysAuthorization))) {
			locationManager.requestAlwaysAuthorization()
		}
		
		self.locationManager.startUpdatingLocation()

	}
}