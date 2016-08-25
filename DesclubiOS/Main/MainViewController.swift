//
//  MainViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 23/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit

class MainViewController: MembershipBaseUIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

	
	@IBOutlet var commonView: UIView!
	@IBOutlet weak var categoriesCollectionView: UICollectionView!
	@IBOutlet weak var logoHeader: UIImageView!
	@IBOutlet weak var searchTextField: UITextField!
	
	private var categories:[FakeCategoryRepresentation] = []
	
	var tap:UITapGestureRecognizer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//config textfield
		
		tap	= UITapGestureRecognizer(target: self, action: #selector(MainViewController.dismissKeyboard))

		
		//move input if keyboard is shown
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
		
		self.searchTextField.delegate = self;
		
		// Do any additional setup after loading the view.
		self.edgesForExtendedLayout = UIRectEdge.None
		UINavigationBar.appearance().barTintColor = ColorUtil.desclubBlueColor()
		UINavigationBar.appearance().tintColor = UIColor.whiteColor()
		
		//collection view confif
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		
		categoriesCollectionView.collectionViewLayout = layout
		
		categoriesCollectionView.dataSource = self
		categoriesCollectionView.delegate = self
		
		//cells
		let nibCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
		categoriesCollectionView.registerNib(nibCell, forCellWithReuseIdentifier: "categoryCollectionViewCell")
		
		
		categoriesCollectionView.backgroundColor = UIColor.whiteColor()
		
		self.initializeCategories()
		
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
        GoogleAnalitycUtil.trackScreenName("analytics.screen.home")

		if UserHelper.isLoggedIn() && UserHelper.isSalud(){
			if categories.count == 8 {
				let redMedica = FakeCategoryRepresentation(_id: "-1", name: "Red Médica", image: "red_medica", color: UIColor.redColor())
				categories.append(redMedica)
			}
		}else{
			if categories.count > 8 {
				categories.removeAtIndex(categories.count-1)
			}
		}
		
		categoriesCollectionView.reloadData()
		
		//important to set this
		self.sourveView = logoHeader
		
		if !UserHelper.isLoggedIn() {
			
			let currentTime = CFAbsoluteTimeGetCurrent()
			let diffTime = currentTime - UserHelper.getTimeSinceLastLogin()
			let maxDiffTime = 1800.0 //30 mins
			
			if diffTime > maxDiffTime {
				UserHelper.setTimeSinceLastLogin(currentTime)
				showMembershipModal()
			}
		}
		
		self.navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
		categoriesCollectionView.performBatchUpdates(nil, completion: nil)
	}
	
	/**
	Initializes the category list
	*/
	private func initializeCategories(){
		
		let alimentos = FakeCategoryRepresentation(_id: CommonConstants.CATEGORY_ALIMENTOS, name: "Alimentos", image: "alimentos", color: ColorUtil.alimentosColor())
		let bellezaSalud = FakeCategoryRepresentation(_id: CommonConstants.CATEGORY_BELLEZA_SALUD, name: "Belleza y Salud", image: "belleza_salud", color: ColorUtil.bellezaSaludColor())
		let educacion = FakeCategoryRepresentation(_id: CommonConstants.CATEGORY_EDUCACION, name: "Educación", image: "educacion", color: ColorUtil.educacionColor())
		let entretenimiento = FakeCategoryRepresentation(_id: CommonConstants.CATEGORY_ENTRETENIMIENTO, name: "Entretenimiento", image: "entretenimiento", color: ColorUtil.entretenimientoColor())
		let modaHogar = FakeCategoryRepresentation(_id: CommonConstants.CATEGORY_MODA_HOGAR, name: "Moda y Hogar", image: "moda_hogar", color: ColorUtil.modaColor())
		let servicios = FakeCategoryRepresentation(_id: CommonConstants.CATEGORY_SERVICIOS, name: "Servicios", image: "servicios", color: ColorUtil.serviciosColor())
		let turismo = FakeCategoryRepresentation(_id: CommonConstants.CATEGORY_TURISMO, name: "Turismo", image: "turismo", color: ColorUtil.turismoColor())
		let todas = FakeCategoryRepresentation(_id: "0", name: "Ver todas", image: "ver_todas", color: ColorUtil.allColor())
		
		
		
		categories.append(alimentos)
		categories.append(bellezaSalud)
		categories.append(educacion)
		categories.append(entretenimiento)
		categories.append(modaHogar)
		categories.append(servicios)
		categories.append(turismo)
		categories.append(todas)
		
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
		if self.categories.count > indexPath.row {
			
			let selectedCategory:FakeCategoryRepresentation = self.categories[indexPath.row]
            
            if let name = selectedCategory.name {
                let event = "Categoria - " + name
                GoogleAnalitycUtil.trackEvent("analytics.category.category", event: event)
            }
			
			if(selectedCategory._id == "-1"){
				
				let saludViewController = SaludViewController(nibName: "SaludViewController", bundle: nil)
				
				let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
				
				appDelegate.globalNavigationController.pushViewController(saludViewController, animated: true)
				
			}else{
				
				let discountsViewController = DiscountsViewController(nibName: "DiscountsViewController", bundle: nil, currentCategory: selectedCategory)
				
				let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
				
				appDelegate.globalNavigationController.pushViewController(discountsViewController, animated: true)
			}
			
		}
		
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = categoriesCollectionView.dequeueReusableCellWithReuseIdentifier("categoryCollectionViewCell", forIndexPath: indexPath) as! CategoryCollectionViewCell
		
		if(self.categories.count > indexPath.row){
		
			let category:FakeCategoryRepresentation = self.categories[indexPath.row]
			
			cell.textLabel?.text = category.name
			cell.imageView?.image = UIImage(named: category.image!)
			
			let viewWidth = cell.frame.size.width
			cell.imageView?.sizeThatFits(CGSize(width: viewWidth, height: viewWidth))
			
		}

		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		
		let viewWidth = collectionView.frame.size.width - 40;
		
		return CGSize(width: viewWidth/3 - 1, height: (viewWidth/3) + 10)
		
	}
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return categories.count
	}

	
	func keyboardWillShow(sender: NSNotification) {
		//Looks for single or multiple taps.
		commonView.addGestureRecognizer(tap)
		
		self.view.frame.origin.y = -10
	}
	func keyboardWillHide(sender: NSNotification) {
		commonView.removeGestureRecognizer(tap)
		self.view.frame.origin.y = 0
	}
	
	//Calls this function when the tap is recognized.
	func dismissKeyboard(){
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		commonView.endEditing(true)
		self.view.frame.origin.y = 0
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		self.view.endEditing(true)
		
		var index = self.categories.count - 1
		
		if UserHelper.isLoggedIn() && UserHelper.isSalud() {
			index = self.categories.count - 2
		}
		
		let discountsViewController = DiscountsViewController(nibName: "DiscountsViewController", bundle: nil, currentCategory: self.categories[index])
		if let text = searchTextField.text{
			discountsViewController.searchString = text
		}
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		
		appDelegate.globalNavigationController.pushViewController(discountsViewController, animated: true)
		
		return false
	}
	
}
