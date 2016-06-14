//
//  MembershipBaseUIViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 15/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class MembershipBaseUIViewController:UIViewController, UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate {
	
	
	var sourveView:UIView?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	func showMembershipModal(){
		let membershipOptionsViewController:MembershipOptionsViewController = MembershipOptionsViewController(nibName: "MembershipOptionsViewController", bundle: nil, delegate:self)
		membershipOptionsViewController.modalPresentationStyle = .Popover
		membershipOptionsViewController.preferredContentSize = CGSizeMake(320, 173)
		
		
		//configure it
		if let popoverController = membershipOptionsViewController.popoverPresentationController {
			if let sourveView =  self.sourveView {
				popoverController.sourceView = sourveView
				popoverController.sourceRect = sourveView.bounds
			}
			popoverController.permittedArrowDirections = .Any
			popoverController.delegate = self
		}
		
		// Present it
		self.presentViewController(membershipOptionsViewController, animated: true, completion: nil)
	}
	
	func showMembershipAccessModal(){
		let membershipAccessViewController:MembershipAccessViewController = MembershipAccessViewController(nibName: "MembershipAccessViewController", bundle: nil, delegate:self)
		membershipAccessViewController.modalPresentationStyle = .Popover
		membershipAccessViewController.preferredContentSize = CGSizeMake(350, 311)
		
		
		//configure it
		if let popoverController = membershipAccessViewController.popoverPresentationController {
			if let sourveView =  self.sourveView {
				popoverController.sourceView = sourveView
				popoverController.sourceRect = sourveView.bounds
			}
			popoverController.permittedArrowDirections = .Any
			popoverController.delegate = self
		}
		
		// Present it
		self.presentViewController(membershipAccessViewController, animated: true, completion: nil)
		
	}
	
	
	func afterLogin(){
		self.view.setNeedsDisplay()
	}

	
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.None
	}
	
}