//
//  ZonesFilterViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 1/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit

class ZonesFilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	
	var delegate : ZonesFilterViewControllerDelegate?
	@IBOutlet weak var zonesPicker: UIPickerView!
	
	
	var currentZone:ZoneRepresentation?
	var currentState:StateRepresentation?
	
	var pickerData: [ZoneRepresentation] = [ZoneRepresentation]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// Connect data:
		self.zonesPicker.delegate = self
		self.zonesPicker.dataSource = self
		
		loadZones()
		
		let allZones:ZoneRepresentation = ZoneRepresentation(_id: nil, name: "Todos")
		pickerData.append(allZones)
    }
    

	// The number of columns of data
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	// The number of rows of data
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerData.count
	}
	
	// The data to return for the row and component (column) that's being passed in
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickerData[row].name
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.currentZone = pickerData[row]
	}
	
	@IBAction func closeFilter(sender: UIButton) {
		if let delegate = self.delegate
		{
			if let zone = self.currentZone {
				delegate.saveZone(zone)
			}
		}
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	private func loadZones(){
		
		SwiftSpinner.show("Cargando zonas ...")
		
		/// completion handler
		let completionHandler: (zonesList:[ZoneRepresentation]?) -> Void = { (zonesList: [ZoneRepresentation]?) in
			
			SwiftSpinner.hide()
			
			if let zonesList = zonesList {
				self.pickerData.appendContentsOf(zonesList)
			}
			
			self.zonesPicker.reloadAllComponents()
			
			//pre-select state
			if let currentZone = self.currentZone {
				var counter = 0
				for state in self.pickerData {
					if currentZone._id == state._id {
						self.zonesPicker.selectRow(counter, inComponent: 0, animated: true)
					}
					counter++
				}
			}
			
		}
		
		/// error hander for getHotelById
		let errorHandler: (error: ErrorType?) -> Void = { (error:ErrorType?) in
			
			SwiftSpinner.hide()
			
		}
		
		var searchParameters:[String:String] = [
			"offset": "0",
			"limit": "50"]
		
		if let stateId = self.currentState?.stateId {
			searchParameters.updateValue(stateId.description, forKey: "stateId")
		}
		
		ZoneFacade.sharedInstance.getAllZones(self, searchParams: searchParameters,completionHandler: completionHandler, errorHandler: errorHandler)
		
	}


}

protocol ZonesFilterViewControllerDelegate{
	func saveZone(var zone : ZoneRepresentation)
}