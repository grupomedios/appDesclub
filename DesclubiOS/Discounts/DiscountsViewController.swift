//
//  DiscountsViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 29/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit
import CoreLocation

class DiscountsViewController: AbstractLocationViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, StatesFilterViewControllerDelegate, ZonesFilterViewControllerDelegate, CategoriesFilterViewControllerDelegate, SubcategoriesFilterViewControllerDelegate {
    
    @IBOutlet weak var loadingIndicatorView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var discountsTableView: UITableView!
    
    private var refreshControl:UIRefreshControl!
    private var isLoading:Bool = false
    private var isRefreshing:Bool = false
    private var previousTotal:Int = -1
    
    
    var searchString:String = ""
    private var searchState:StateRepresentation?
    private var searchZone:ZoneRepresentation?
    private var searchCategory:CategoryRepresentation?
    private var searchSubcategory:SubcategoryRepresentation?
    
    private var currentCategory:FakeCategoryRepresentation
    private var discounts:[NearByDiscountRepresentation] = [NearByDiscountRepresentation]()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, currentCategory:FakeCategoryRepresentation) {
        self.currentCategory = currentCategory
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.discountsTableView.delegate = self
        self.discountsTableView.dataSource = self
        
        self.discountsTableView.tableFooterView = UIView()
        
        //register custom cell
        let nib = UINib(nibName: "DiscountTableViewCell", bundle: nil)
        discountsTableView.registerNib(nib, forCellReuseIdentifier: "discountTableViewCell")
        
        setUpLoadingIndicators()
        
        //pre-assign category if exists
        if self.currentCategory._id != "0"{
            self.searchCategory = self.currentCategory
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.view.needsUpdateConstraints()
        refresh(nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        GoogleAnalitycUtil.trackScreenName("analytics.screen.discounts_list")
        
        setupCurrentView()
    }
    
    private func setupCurrentView(){
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = currentCategory.name
        
        //change nav bar color and tint color
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        bar.titleTextAttributes = titleDict as? [String : AnyObject]
        bar.barTintColor = currentCategory.color
        bar.shadowImage = UIImage()
        bar.tintColor = UIColor.whiteColor()
        
        //show buttons
        let goToMapButton = UIBarButtonItem(image: UIImage(named: "location"), style: UIBarButtonItemStyle.Done, target: self, action: "goToMap")
        
        //UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem., target: self, action: "goToMap") //Use a selector
        //var searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "search") //Use a selector
        
        navigationItem.rightBarButtonItems = [goToMapButton]//, searchButton]
        
    }
    
    func goToMap() {
        
        let searchMapViewController = SearchMapViewController(nibName: "SearchMapViewController", bundle: nil, currentLocation: currentLocation, searchId: nil, searchString: self.searchString, searchState: self.searchState, searchZone: self.searchZone, searchCategory: self.searchCategory, searchSubcategory: self.searchSubcategory)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.globalNavigationController.presentViewController(searchMapViewController, animated: true, completion:nil)
        
    }
    
    func search() {
        
        print("Yo")
        
    }
    
    
    /**
     Sets up the location indicator
     */
    private func setUpLoadingIndicators(){
        //pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Actualizando ...")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        discountsTableView.addSubview(refreshControl)
        
        spinner.startAnimating()
        spinner.transform = CGAffineTransformMakeScale(1.75, 1.75);
        
    }
    
    /**
     Load new results when scrolling
     */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //		if UserHelper.isLoggedIn() {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 {
            loadDiscounts()
        }
        //		}
        
    }
    
    /**
     Pull on refresh listener
     */
    func refresh(sender:AnyObject?){
        if !isRefreshing {
            refreshSearch()
        }else{
            self.refreshControl.endRefreshing()
        }
    }
    
    /**
     refreshes or clears the search results list
     */
    func refreshSearch(){
        self.isLoading = false
        self.isRefreshing = true
        
        self.previousTotal = -1;
        self.discounts.removeAll(keepCapacity: false)
        self.loadDiscounts()
        
    }
    
    /**
     Shows a message in the background of the table view
     
     :param: labelText the message to show
     */
    private func showEmptyResultsMessage(labelText:String){
        
        if self.discounts.count == 0{
            
            let viewContainer = UIView(frame: CGRectMake(0, 0, self.discountsTableView.bounds.size.width, self.discountsTableView.bounds.size.height))
            
            let messageLabel = UILabel(frame: CGRectMake(0, 0, self.discountsTableView.bounds.size.width, self.discountsTableView.bounds.size.height))
            messageLabel.text = labelText
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.sizeToFit()
            messageLabel.center = self.discountsTableView.center
            
            let tryAgainButton = UIButton(frame: CGRectMake(0, 30, self.discountsTableView.bounds.size.width/2, 40))
            tryAgainButton.setTitle("Intentar de nuevo", forState: UIControlState.Normal)
            tryAgainButton.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.TouchUpInside)
            tryAgainButton.backgroundColor = UIColor.grayColor()
            tryAgainButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
            tryAgainButton.center = CGPointMake(self.discountsTableView.center.x, self.discountsTableView.center.y + tryAgainButton.bounds.height)
            
            viewContainer.addSubview(messageLabel)
            viewContainer.addSubview(tryAgainButton)
            viewContainer.sizeToFit()
            
            self.discountsTableView.backgroundView = viewContainer
        }
        
    }
    
    /**
     Get near by hotels from BeepQuest API
     */
    private func loadDiscounts(){
        
        if(!self.isLoading && self.previousTotal < self.discounts.count && currentLocation != nil){
            
            SwiftSpinner.show("Cargando descuentos")
            self.isLoading = true
            
            loadingIndicatorView.hidden = (self.discounts.count == 0) ? true: false
            
            /// completion handler
            let completionHandler: (discountList:[NearByDiscountRepresentation]?) -> Void = { (discountList: [NearByDiscountRepresentation]?) in
                
                self.previousTotal = self.discounts.count
                
                if let discountList = discountList {
                    self.discounts.appendContentsOf(discountList)
                }
                
                self.discountsTableView.reloadData()
                
                SwiftSpinner.hide()
                self.isLoading = false
                self.isRefreshing = false
                self.loadingIndicatorView.hidden = true
                self.refreshControl.endRefreshing()
                
                self.discountsTableView.backgroundView = nil
                
                self.showEmptyResultsMessage("No hay descuentos cercanos a tu ubicación")
            }
            
            /// error hander for getHotelById
            let errorHandler: (error: ErrorType?) -> Void = { (error:ErrorType?) in
                
                self.discountsTableView.reloadData()
                
                SwiftSpinner.hide()
                
                self.isLoading = false
                self.isRefreshing = false
                self.loadingIndicatorView.hidden = true
                self.refreshControl.endRefreshing()
                
                self.showEmptyResultsMessage("Error de conexión. Verifica tu conexión a internet")
            }
            
            var searchParameters:[String:String] = [
                "latitude": currentLocation.coordinate.latitude.description,
                "longitude": currentLocation.coordinate.longitude.description,
                "limit": "30"]
            
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
            
            if self.discounts.count > 0 {
                let minDistance = self.discounts[self.discounts.count - 1].dis! + 0.0000001
                searchParameters.updateValue(minDistance.description, forKey: "minDistance")
            }
            
            DiscountFacade.sharedInstance.getAllNearByDiscounts(self, searchParams: searchParameters,completionHandler: completionHandler, errorHandler: errorHandler)
        }
        
    }
    
    /**
     // MARK: - TableView
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discounts.count
    }
    
    /**
     action executed when the user taps an discount
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let discount:NearByDiscountRepresentation = self.discounts[indexPath.row]
        
        let discountViewController = DiscountViewController(nibName: "DiscountViewController", bundle: nil, discount:discount.discount!)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.globalNavigationController.pushViewController(discountViewController, animated: true)
        
        self.discountsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    /**
     Configures each row for the table view
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:DiscountTableViewCell = self.discountsTableView.dequeueReusableCellWithIdentifier("discountTableViewCell") as! DiscountTableViewCell
        
        if (self.discounts.count > indexPath.row) {
            
            let discountNear :NearByDiscountRepresentation = self.discounts[indexPath.row]
            
            if let discount = discountNear.discount {
                cell.setupWithDiscount(discount, colorCategory: currentCategory.color!, distance: discountNear.dis!)
            }
            
        }
        
        cell.setNeedsDisplay()
        
        return cell
        
    }
    
    /**
     sets the height of the row
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 134
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 118
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerxib:SearchBarHeader = NSBundle.mainBundle().loadNibNamed("SearchBarHeader", owner: self, options: nil).first as! SearchBarHeader
        
        let backView = UIView(frame: headerxib.frame)
        backView.backgroundColor = currentCategory.color
        
        headerxib.backgroundView = backView
        
        //search string
        headerxib.searchString.text = self.searchString
        headerxib.searchString.delegate = self
        
        //state filter
        if let state = self.searchState {
            if let _ = state._id {
                headerxib.stateFilter.setTitle(state.name, forState: UIControlState.Normal)
            }
        }
        headerxib.stateFilter.addTarget(self, action: "statesFilterPressed:", forControlEvents: .TouchUpInside)
        
        //zone filter
        if let zone = self.searchZone {
            if let _ = zone._id {
                headerxib.zoneFilter.setTitle(zone.name, forState: UIControlState.Normal)
            }
        }
        //hide zones filter in specific cases
        headerxib.zoneFilter.addTarget(self, action: "zonesFilterPressed:", forControlEvents: .TouchUpInside)
        if self.searchState?.stateId != 9 && self.searchState?.stateId != 15 {
            headerxib.zoneFilter.hidden = true
        }else{
            headerxib.zoneFilter.hidden = false
        }
        
        //category filter
        if let category = self.searchCategory {
            if let _ = category._id {
                headerxib.categoryFilter.setTitle(category.name, forState: UIControlState.Normal)
            }
        }
        headerxib.categoryFilter.addTarget(self, action: "categoriesFilterPressed:", forControlEvents: .TouchUpInside)
        
        //subcategory filter
        if let subcategory = self.searchSubcategory {
            if let _ = subcategory._id {
                headerxib.subcategoryFilter.setTitle(subcategory.name, forState: UIControlState.Normal)
            }
        }
        //hide subcategories filter in specific cases
        headerxib.subcategoryFilter.addTarget(self, action: "subcategoriesFilterPressed:", forControlEvents: .TouchUpInside)
        if let _ = self.searchCategory {
            headerxib.subcategoryFilter.hidden = false
        }else{
            headerxib.subcategoryFilter.hidden = true
        }
        
        return headerxib
    }
    
    func statesFilterPressed(sender: UIButton!) {
        let popoverVC:StatesFilterViewController = StatesFilterViewController(nibName: "StatesFilterViewController", bundle: nil)
        popoverVC.modalPresentationStyle = .Popover
        popoverVC.delegate = self
        
        //pre-assign state
        if let state = self.searchState {
            popoverVC.currentState = state
        }
        
        // Present it before configuring it
        presentViewController(popoverVC, animated: true, completion: nil)
        // Now the popoverPresentationController has been created
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
        }
    }
    
    func zonesFilterPressed(sender: UIButton!) {
        if let currentState = self.searchState {
            let popoverVC:ZonesFilterViewController = ZonesFilterViewController(nibName: "ZonesFilterViewController", bundle: nil)
            popoverVC.modalPresentationStyle = .Popover
            popoverVC.delegate = self
            popoverVC.currentState = currentState
            
            //pre-assign zone
            if let zone = self.searchZone {
                popoverVC.currentZone = zone
            }
            
            // Present it before configuring it
            presentViewController(popoverVC, animated: true, completion: nil)
            // Now the popoverPresentationController has been created
            if let popoverController = popoverVC.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
                popoverController.permittedArrowDirections = .Any
                popoverController.delegate = self
            }
        }
    }
    
    func categoriesFilterPressed(sender: UIButton!) {
        let popoverVC:CategoryFilterViewController = CategoryFilterViewController(nibName: "CategoryFilterViewController", bundle: nil)
        popoverVC.modalPresentationStyle = .Popover
        popoverVC.delegate = self
        
        //pre-assign state
        if let category = self.searchCategory {
            popoverVC.currentCategory = category
        }
        
        // Present it before configuring it
        presentViewController(popoverVC, animated: true, completion: nil)
        // Now the popoverPresentationController has been created
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
        }
    }
    
    func subcategoriesFilterPressed(sender: UIButton!) {
        if let currentCategory = self.searchCategory {
            let popoverVC:SubcategoryFilterViewController = SubcategoryFilterViewController(nibName: "SubcategoryFilterViewController", bundle: nil)
            popoverVC.modalPresentationStyle = .Popover
            popoverVC.delegate = self
            popoverVC.currentCategory = currentCategory
            
            //pre-assign subcateggory
            if let subcategory = self.searchSubcategory {
                popoverVC.currentSubcategory = subcategory
            }
            
            // Present it before configuring it
            presentViewController(popoverVC, animated: true, completion: nil)
            // Now the popoverPresentationController has been created
            if let popoverController = popoverVC.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
                popoverController.permittedArrowDirections = .Any
                popoverController.delegate = self
            }
        }
    }
    
    /**
     // MARK: - UITextFieldDelegate
     */
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.searchString = textField.text!
        refreshSearch()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        self.searchString = ""
        refreshSearch()
        textField.resignFirstResponder()
        return true
    }
    
    /**
     // MARK: - Popover Delegates
     */
    
    func saveState(state: StateRepresentation) {
        self.searchState = state
        refreshSearch()
    }
    
    func saveZone(zone: ZoneRepresentation) {
        self.searchZone = zone
        refreshSearch()
    }
    
    func saveCategory(category: CategoryRepresentation) {
        self.searchCategory = category
        refreshSearch()
    }
    
    func saveSubcategory(subcategory: SubcategoryRepresentation) {
        self.searchSubcategory = subcategory
        refreshSearch()
    }
    
    /**
     // MARK: - CoreLocation
     
     Core location listener for updated location
     */
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        if self.currentLocation != nil {
            if self.discounts.count == 0 && self.previousTotal < 0 {
                refresh(nil)
            }
            return;
        }
        
        self.currentLocation = newLocation
        
        refresh(nil)
    }
    
    /**
     Core location error listener
     */
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        if self.currentLocation != nil {
            if self.discounts.count == 0 {
                refresh(nil)
            }
            return;
        }
        self.currentLocation = CLLocation(latitude: CommonConstants.defaultLatitude, longitude: CommonConstants.defaultLongitude)
        
        refresh(nil)
    }
    
    /**
     //MARK: - SearchBar
     
     */
    
    
    
    /**
     
     //MARK: - Utils
     
     Calculates the distance (in meters or kilometers) and sets the label string
     :param: distanceInKm the distance in km
     
     :returns: the string distance
     */
    private func calculateDistance(distanceInKm:Double) -> String{
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = 2
        
        if distanceInKm < 1 {
            return formatter.stringFromNumber(distanceInKm * 1000)! + " m"
        }else{
            return formatter.stringFromNumber(distanceInKm)! + " km"
        }
    }
    
    
    
    
}
