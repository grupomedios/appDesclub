//
//  DiscountPopoverViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 2/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit

class DiscountPopoverViewController: UIViewController {

	
	@IBOutlet weak var discountImage: UIImageView!
	@IBOutlet weak var branchName: UILabel!
	@IBOutlet weak var branchAddress: UILabel!
	
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
		let gesture = UITapGestureRecognizer(target: self, action: "tappedDiscount:")
		self.view.addGestureRecognizer(gesture)
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		self.branchName.text = self.discount.branch?.name
		self.branchAddress.text = self.discount.branch?.getCompleteAddress()
		
		//show logo image
		if self.discount.brand?.logoSmall != nil {
			if let logoPath = discount.brand?.logoSmall {
				ImageLoader.sharedLoader.imageForUrl(logoPath, completionHandler:{(image: UIImage?, url: String) in
					if let loadedImage = image {
						self.discountImage.image = loadedImage
					}else{
						self.discountImage.image = UIImage(named: "logo")
					}
				})
			}
		}
		
	}

	func tappedDiscount(sender:UITapGestureRecognizer){
		let discountViewController = DiscountViewController(nibName: "DiscountViewController", bundle: nil, discount:self.discount)
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.globalNavigationController.pushViewController(discountViewController, animated: true)
		
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
}
