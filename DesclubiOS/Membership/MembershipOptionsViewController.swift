//
//  MembershipOptionsViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 7/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit

class MembershipOptionsViewController: UIViewController,UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate {
	
	var delegate:MembershipBaseUIViewController!
	@IBOutlet weak var accessButton: UIButton!
	
	init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, delegate:MembershipBaseUIViewController) {
		
		self.delegate = delegate
		
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		accessButton.titleLabel!.textAlignment = .Center
    }
	
	@IBAction func closeModal(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func explore(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	@IBAction func access(sender: UIButton) {
		
		self.dismissViewControllerAnimated(true, completion: {
			self.delegate.showMembershipAccessModal()
		})
		
	}
	
	
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.None
	}


}
