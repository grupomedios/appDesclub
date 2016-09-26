//
//  MapViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 23/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate {

	
	@IBOutlet weak var mapView: MKMapView!
	
	private var searchString:String = ""
	private var searchState:StateRepresentation?
	private var searchZone:ZoneRepresentation?
	private var searchCategory:CategoryRepresentation?
	private var searchSubcategory:SubcategoryRepresentation?
	
	private var alreadyLocated = false
	
	var locationManager = CLLocationManager()
	
	// set initial location in Honolulu
	let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		locationManager.delegate = self
		mapView.delegate = self
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
        GoogleAnalitycUtil.trackScreenName("analytics.screen.map_tab")
        
		self.edgesForExtendedLayout = UIRectEdge.None
		self.navigationController?.setNavigationBarHidden(true, animated: true)
		
		checkLocationAuthorizationStatus()
	}
	
	func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
		
		if !alreadyLocated {
			centerMapInCurrentLocation()
			alreadyLocated = true
		}
	}
	
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		if (annotation is MKUserLocation) {
			return nil
		}
		else {
			let annotationView = DiscountAnnotationView(annotation: annotation, reuseIdentifier: "DiscountAnnotationView")
			annotationView.canShowCallout = false
			return annotationView
		}
	}
	
	func mapView(mapView: MKMapView,didSelectAnnotationView view: MKAnnotationView){
		
		if view.isKindOfClass(DiscountAnnotationView) {
			
			let castedView:DiscountAnnotationView = view as! DiscountAnnotationView
			let discountAnnotation:DiscountAnnotation = castedView.annotation as! DiscountAnnotation

			
			let discountPopoverViewController:DiscountPopoverViewController = DiscountPopoverViewController(nibName: "DiscountPopoverViewController", bundle: nil, discount: discountAnnotation.discount)
			discountPopoverViewController.modalPresentationStyle = .Popover
			discountPopoverViewController.preferredContentSize = CGSizeMake(180, 80)
			
			
			//configure it
			if let popoverController = discountPopoverViewController.popoverPresentationController {
				popoverController.sourceView = view
				popoverController.sourceRect = view.bounds
				popoverController.permittedArrowDirections = .Any
				popoverController.delegate = self
			}
			
			// Present it
			presentViewController(discountPopoverViewController, animated: true, completion: nil)
		
		}
		
	}
	
	func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		//remove all annotations first
//		mapView.removeAnnotations(mapView.annotations)
		
		//then reload
		loadAllDiscounts()
	}
	
	private func centerMapInCurrentLocation(){
		let userLocation = mapView.userLocation
		
		if let location =  userLocation.location{
			let region = MKCoordinateRegionMakeWithDistance(
				location.coordinate, 2000, 2000)
			
			mapView.setRegion(region, animated: true)
		}
	}

	
	private func loadDiscountsInLocation(latitude:Double, longitude:Double){
		
		if !latitude.isNaN && !longitude.isNaN {
			
			/// completion handler
			let completionHandler: (discountList:[NearByDiscountRepresentation]?) -> Void = { (discountList: [NearByDiscountRepresentation]?) in
				SwiftSpinner.hide()
				
				if let discountList = discountList {
					for discount in discountList {
						
						let discountAnnotation = DiscountAnnotation(discount: discount)
						self.mapView.addAnnotation(discountAnnotation)
						
					}
				}
				
			}
			
			/// error hander for getHotelById
			let errorHandler: (error: ErrorType?) -> Void = { (error:ErrorType?) in
				SwiftSpinner.hide()
			}
			
			var searchParameters:[String:String] = [
				"latitude": latitude.description,
				"longitude": longitude.description,
				"limit": "15"]
			
			if !self.searchString.isEmpty {
				searchParameters.updateValue(self.searchString, forKey: "branchName")
			}
			
			if let state = self.searchState {
				if let stateId = state._id {
					searchParameters.updateValue(stateId, forKey: "state")
				}
			}
			
			if let zone = self.searchZone {
				if let zoneId = zone._id {
					searchParameters.updateValue(zoneId, forKey: "zone")
				}
			}
			
			if let category = self.searchCategory {
				if let categoryId = category._id {
					if categoryId != "0"{
						searchParameters.updateValue(categoryId, forKey: "category")
					}
				}
			}
			
			if let subcategory = self.searchSubcategory {
				if let subcategoryId = subcategory._id {
					searchParameters.updateValue(subcategoryId, forKey: "subcategory")
				}
			}
			
			DiscountFacade.sharedInstance.getAllNearByDiscounts(self, searchParams: searchParameters,completionHandler: completionHandler, errorHandler: errorHandler)
			
		}

		
	}
	
	
	private func loadAllDiscounts(){
		
		//load in center of map
		let center = mapView.region.center
		loadDiscountsInLocation(center.latitude, longitude: center.longitude)
		
		
		let nePoint = CGPoint(x: mapView.bounds.maxX, y: mapView.bounds.origin.y)
		let neCoord = mapView.convertPoint(nePoint, toCoordinateFromView: mapView)
		let neLat = (center.latitude + neCoord.latitude) / 2
		let neLon = (center.longitude + neCoord.longitude) / 2
		loadDiscountsInLocation(neLat, longitude: neLon)
		
		let nwPoint = CGPoint(x: mapView.bounds.minX, y: mapView.bounds.origin.y)
		let nwCoord = mapView.convertPoint(nwPoint, toCoordinateFromView: mapView)
		let nwLat = (center.latitude + nwCoord.latitude) / 2
		let nwLon = (center.longitude + nwCoord.longitude) / 2
		loadDiscountsInLocation(nwLat, longitude: nwLon)
		
		
		let swPoint = CGPoint(x: mapView.bounds.minX, y: mapView.bounds.maxY)
		let swCoord = mapView.convertPoint(swPoint, toCoordinateFromView: mapView)
		let swLat = (center.latitude + swCoord.latitude) / 2
		let swLon = (center.longitude + swCoord.longitude) / 2
		loadDiscountsInLocation(swLat, longitude: swLon)
		
		let sePoint = CGPoint(x: mapView.bounds.maxX, y: mapView.bounds.maxY)
		let seCoord = mapView.convertPoint(sePoint, toCoordinateFromView: mapView)
		let seLat = (center.latitude + seCoord.latitude) / 2
		let seLon = (center.longitude + seCoord.longitude) / 2
		loadDiscountsInLocation(seLat, longitude: seLon)
		
	}

	
	func checkLocationAuthorizationStatus() {
		if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
			mapView.showsUserLocation = true
		} else {
			locationManager.requestAlwaysAuthorization()
		}
	}
	
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.None
	}
	
}
