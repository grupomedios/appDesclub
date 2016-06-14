//
//  StatesFilterViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 31/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit

class StatesFilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	var delegate : StatesFilterViewControllerDelegate?
	
	@IBOutlet weak var okButton: UIButton!
	@IBOutlet weak var statesPicker: UIPickerView!
	
	var currentState:StateRepresentation?
	
	var pickerData: [StateRepresentation] = [StateRepresentation]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		// Connect data:
		self.statesPicker.delegate = self
		self.statesPicker.dataSource = self
		
		loadStates()
		
		let allStates:StateRepresentation = StateRepresentation(_id: nil, name: "Todos")
		pickerData.append(allStates)
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
		
		self.currentState = pickerData[row]
		
	}
	
	@IBAction func closeFilter(sender: UIButton) {
		if let delegate = self.delegate
		{
			if let state = self.currentState {
				delegate.saveState(state)
			}
		}
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	private func loadStates(){
		
		SwiftSpinner.show("Cargando estados ...")
		
		/// completion handler
		let completionHandler: (statesList:[StateRepresentation]?) -> Void = { (statesList: [StateRepresentation]?) in
			
			SwiftSpinner.hide()
			
			if let statesList = statesList {
				self.pickerData.appendContentsOf(statesList)
			}
			
			self.statesPicker.reloadAllComponents()
			
			//pre-select state
			if let currentState = self.currentState {
				var counter = 0
				for state in self.pickerData {
					if currentState._id == state._id {
						self.statesPicker.selectRow(counter, inComponent: 0, animated: true)
					}
					counter++
				}
			}
			
		}
		
		/// error hander for getHotelById
		let errorHandler: (error: ErrorType?) -> Void = { (error:ErrorType?) in
			
			SwiftSpinner.hide()
			
		}
		
		let searchParameters:[String:String] = [
			"offset": "0",
			"limit": "50"]
		
		StateFacade.sharedInstance.getAllStates(self, searchParams: searchParameters,completionHandler: completionHandler, errorHandler: errorHandler)
		
	}
	

}

protocol StatesFilterViewControllerDelegate{
	func saveState(var stateId : StateRepresentation)
}
