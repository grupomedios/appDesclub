//
//  SaludViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 10/11/15.
//  Copyright © 2015 Grupo Medios. All rights reserved.
//

import UIKit

class SaludViewController: UIViewController {

	@IBOutlet weak var clockLabel: UILabel!
	@IBOutlet weak var cardNumber: UILabel!
	@IBOutlet weak var validThru: UILabel!
	@IBOutlet weak var name: UILabel!
	
	var timer = NSTimer()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
			target: self,
			selector: Selector("tick"),
			userInfo: nil,
			repeats: true)
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		let value = UIInterfaceOrientation.Portrait.rawValue
		UIDevice.currentDevice().setValue(value, forKey: "orientation")
		
		self.edgesForExtendedLayout = UIRectEdge.None
		self.navigationController?.setNavigationBarHidden(false, animated: true)
		self.title = "Desclub + Salud"
		
		//change nav bar color and tint color
		let bar:UINavigationBar! =  self.navigationController?.navigationBar
		let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		bar.titleTextAttributes = titleDict as? [String : AnyObject]
		bar.shadowImage = UIImage()
		bar.tintColor = UIColor.whiteColor()
		
		//show card information
		let membership:CorporateMembershipRepresentation = UserHelper.getCurrentUser()!
		self.name?.text = membership.name?.uppercaseString
		self.cardNumber?.text = UserHelper.getSaludNumber()
		self.validThru.text = "VENCE " + UserHelper.getValidThru()
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
	
	
}
