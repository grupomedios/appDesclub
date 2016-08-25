//
//  CardPopoverViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 3/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit

class CardPopoverViewController: UIViewController {

	@IBOutlet weak var cardView: UIView!
	@IBOutlet weak var showMessageView: UIView!
	
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var cardNumber: UILabel!
	@IBOutlet weak var clockLabel: UILabel!
	@IBOutlet weak var validThru: UILabel!
	
	
	var timer = NSTimer()
	
	var discount:DiscountRepresentation
	
	init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, discount:DiscountRepresentation) {
		self.discount = discount
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
			target: self,
			selector: #selector(CardPopoverViewController.tick),
			userInfo: nil,
			repeats: true)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		let value = UIInterfaceOrientation.LandscapeLeft.rawValue
		UIDevice.currentDevice().setValue(value, forKey: "orientation")
		
		self.showAndHideComponents()
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		
		let value = UIInterfaceOrientation.Portrait.rawValue
		UIDevice.currentDevice().setValue(value, forKey: "orientation")
	}
	
	@objc func tick() {
		clockLabel.text = NSDateFormatter.localizedStringFromDate(NSDate(),
			dateStyle: .MediumStyle,
			timeStyle: .MediumStyle)
	}
	
	private func showAndHideComponents(){
		if UserHelper.isLoggedIn() {
			
			cardView.hidden = false
			showMessageView.hidden = true
			
			//show card information
			let membership:CorporateMembershipRepresentation = UserHelper.getCurrentUser()!
			self.name?.text = membership.name?.uppercaseString
			self.cardNumber?.text = UserHelper.getCardNumber()
			self.validThru.text = UserHelper.getValidThru()
			
		}else{
			cardView.hidden = true
			showMessageView.hidden = false
		}
	}
	
	@IBAction func closeModal(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	

}
