//
//  SubcategoryFilterViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 1/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit

class SubcategoryFilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	var delegate : SubcategoriesFilterViewControllerDelegate?

	@IBOutlet weak var subcategoriesPicker: UIPickerView!
	
	var currentSubcategory:SubcategoryRepresentation?
	var currentCategory:CategoryRepresentation?
	
	var pickerData: [SubcategoryRepresentation] = [SubcategoryRepresentation]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// Connect data:
		self.subcategoriesPicker.delegate = self
		self.subcategoriesPicker.dataSource = self
		
		loadSubcategories()
		
		let allSubcategories:SubcategoryRepresentation = SubcategoryRepresentation(_id: nil, name: "Todos")
		pickerData.append(allSubcategories)

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
		self.currentSubcategory = pickerData[row]
	}
	
	@IBAction func closeFilter(sender: UIButton) {
		if let delegate = self.delegate
		{
			if let subcategory = self.currentSubcategory {
				delegate.saveSubcategory(subcategory)
			}
		}
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	private func loadSubcategories(){
		
		SwiftSpinner.show("Cargando subgiros ...")
		
		/// completion handler
		let completionHandler: (subcategoriesList:[SubcategoryRepresentation]?) -> Void = { (subcategoriesList: [SubcategoryRepresentation]?) in
			
			SwiftSpinner.hide()
			
			if let subcategoriesList = subcategoriesList {
				self.pickerData.appendContentsOf(subcategoriesList)
			}
			
			self.subcategoriesPicker.reloadAllComponents()
			
			//pre-select state
			if let currentSubcategory = self.currentSubcategory {
				var counter = 0
				for subcat in self.pickerData {
					if currentSubcategory._id == subcat._id {
						self.subcategoriesPicker.selectRow(counter, inComponent: 0, animated: true)
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
		
		if let categoryId = currentCategory?._id {
			CategoryFacade.sharedInstance.getAllSubcategories(self, category: categoryId, searchParams: searchParameters,completionHandler: completionHandler, errorHandler: errorHandler)
		}
		
	}

}

protocol SubcategoriesFilterViewControllerDelegate{
	func saveSubcategory(var subcategory : SubcategoryRepresentation)
}