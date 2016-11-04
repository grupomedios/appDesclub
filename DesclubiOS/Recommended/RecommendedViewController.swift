//
//  RecommendedViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 23/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit

class RecommendedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	
	@IBOutlet weak var loadingIndicatorView: UIView!
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	@IBOutlet weak var discountsTableView: UITableView!
	
	
	private var discounts:[DiscountRepresentation] = [DiscountRepresentation]()
	
	private var refreshControl:UIRefreshControl!
	private var isLoading:Bool = false
	private var isRefreshing:Bool = false
	private var previousTotal:Int = -1
	
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

    }
	
	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		self.view.needsUpdateConstraints()
		refresh(nil)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
        GoogleAnalitycUtil.trackScreenName("analytics.screen.recommended")

		setupCurrentView()
		refresh(nil)
	}
	
	private func setupCurrentView(){
		
		self.edgesForExtendedLayout = UIRectEdge.None
		
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
		self.isRefreshing = false
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
		
		let offset = self.discounts.count
		
		if(!self.isLoading && !self.isRefreshing && self.previousTotal < self.discounts.count){
			
			SwiftSpinner.show("Cargando descuentos")
			self.isLoading = true
			
			loadingIndicatorView.hidden = (self.discounts.count == 0) ? true: false
			
			/// completion handler
			let completionHandler: (discountList:[DiscountRepresentation]?) -> Void = { (discountList: [DiscountRepresentation]?) in
				
				self.previousTotal = self.discounts.count
				
				if let discountList = discountList {
					self.discounts.appendContentsOf(discountList)
				}
				
				self.discountsTableView.reloadData()
				
				SwiftSpinner.hide()
				self.isLoading = false
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
			
			let searchParameters:[String:String] = [
				"offset": offset.description,
				"limit": "10"
			]
			
			DiscountFacade.sharedInstance.getAllRecommendedDiscounts(self, searchParams: searchParameters,completionHandler: completionHandler, errorHandler: errorHandler)
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
		
		let discount:DiscountRepresentation = self.discounts[indexPath.row]
		
		let discountViewController = DiscountViewController(nibName: "DiscountViewController", bundle: nil, discount:discount)
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
			
			let discount:DiscountRepresentation = self.discounts[indexPath.row]
			cell.setupWithDiscount(discount)
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

}
