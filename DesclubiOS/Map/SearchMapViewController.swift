//
//  SearchMapViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 7/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit
import MapKit

class SearchMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate {

	
	@IBOutlet weak var mapView: MKMapView!
	
	private var searchId:String?
	private var searchString:String?
	private var searchState:StateRepresentation?
	private var searchZone:ZoneRepresentation?
	private var searchCategory:CategoryRepresentation?
	private var searchSubcategory:SubcategoryRepresentation?
	private var currentLocation:CLLocation!
	
	
	init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, currentLocation:CLLocation, searchId:String?, searchString:String?,searchState:StateRepresentation?,searchZone:ZoneRepresentation?,searchCategory:CategoryRepresentation?,searchSubcategory:SubcategoryRepresentation?) {
		
		self.searchId = searchId
		self.searchString = searchString
		self.searchState = searchState
		self.searchZone = searchZone
		self.searchCategory = searchCategory
		self.searchSubcategory = searchSubcategory
		self.currentLocation = currentLocation
		
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		mapView.delegate = self
		
		loadAllDiscounts()
    }
	
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.edgesForExtendedLayout = UIRectEdge.None
		self.navigationController?.setNavigationBarHidden(true, animated: true)
		
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
	
	func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
		
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
	
	private func loadAllDiscounts(){
		
		SwiftSpinner.show("Cargando resultados")
		
		/// completion handler
		let completionHandler: (discountList:[NearByDiscountRepresentation]?) -> Void = { (discountList: [NearByDiscountRepresentation]?) in
			
			SwiftSpinner.hide()
			
			if let discountList = discountList {
				
				//center map in firts result
				if discountList.count > 0 {
					let firstDiscountNearBy:NearByDiscountRepresentation = discountList[0] as NearByDiscountRepresentation
					
					print(firstDiscountNearBy.dis)
					print(firstDiscountNearBy.discount?.branch?.name)
					let firstDiscount = firstDiscountNearBy.discount!
					
					if let location = firstDiscount.location {
						if let coordinates = location.coordinates {
							
							let firstLat = coordinates[1]
							let firstLon = coordinates[0]
							let centerCoordinate = CLLocationCoordinate2D(latitude: firstLat, longitude:  firstLon)
							
							let region = MKCoordinateRegionMakeWithDistance(
								centerCoordinate, 6000, 6000)
							
							self.mapView.setRegion(region, animated: true)
						}
					}
				}
				
				//add all annotations
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
		
		var latitude = "0.0"
		var longitude = "0.0"
		
		if let currentLocation = self.currentLocation {
			
			print(currentLocation)
			print(currentLocation.coordinate.latitude.description)
			
			latitude = currentLocation.coordinate.latitude.description
			longitude = currentLocation.coordinate.longitude.description
		}
		
		
		var searchParameters:[String:String] = [
			"latitude": latitude,
			"longitude": longitude,
			"limit": "100"]
		
		if let searchId = self.searchId{
			if !searchId.isEmpty {
				searchParameters.updateValue(searchId, forKey: "_id")
			}
		}
		
		if let searchString = self.searchString{
			if !searchString.isEmpty {
				searchParameters.updateValue(searchString, forKey: "branchName")
			}
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
		
		print(searchParameters)
		
		DiscountFacade.sharedInstance.getAllNearByDiscounts(self, searchParams: searchParameters,completionHandler: completionHandler, errorHandler: errorHandler)
		
	}
	
	
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.None
	}
	
	
	@IBAction func closeMap(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}

}
