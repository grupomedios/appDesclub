//
//  CategoryFilterViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 1/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit

class CategoryFilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	var delegate : CategoriesFilterViewControllerDelegate?
	
	@IBOutlet weak var categoriesPicker: UIPickerView!
	
	var currentCategory:CategoryRepresentation?
	
	var pickerData: [CategoryRepresentation] = [CategoryRepresentation]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// Connect data:
		self.categoriesPicker.delegate = self
		self.categoriesPicker.dataSource = self
		
		loadCategories()
		
		let allCategories:CategoryRepresentation = CategoryRepresentation(_id: nil, name: "Todos")
		pickerData.append(allCategories)

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
		self.currentCategory = pickerData[row]
	}

	
	@IBAction func closeFilter(sender: UIButton) {
		if let delegate = self.delegate
		{
			if let category = self.currentCategory {
				delegate.saveCategory(category)
			}
		}
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	private func loadCategories(){
		
		SwiftSpinner.show("Cargando categorias ...")
		
		/// completion handler
		let completionHandler: (categoriesList:[CategoryRepresentation]?) -> Void = { (categoriesList: [CategoryRepresentation]?) in
			
			SwiftSpinner.hide()
			
			if let categoriesList = categoriesList {
				self.pickerData.appendContentsOf(categoriesList)
			}
			
			self.categoriesPicker.reloadAllComponents()
			
			//pre-select state
			if let currentCategory = self.currentCategory {
				var counter = 0
				for state in self.pickerData {
					if currentCategory._id == state._id {
						self.categoriesPicker.selectRow(counter, inComponent: 0, animated: true)
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
		
		
		CategoryFacade.sharedInstance.getAllCategories(self, searchParams: searchParameters,completionHandler: completionHandler, errorHandler: errorHandler)
		
	}
	

}

protocol CategoriesFilterViewControllerDelegate{
	func saveCategory(var category : CategoryRepresentation)
}