//
//  NavigationUtil.swift
//  BeepQuest
//
//  Created by Jhon Cruz on 9/03/15.
//  Copyright (c) 2015 GQuest. All rights reserved.
//

import Foundation
import UIKit

struct NavigationUtil {
	
	/**
	Presents the main view controller
	*/
	static func presentMainViewController(){
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		
		appDelegate.buildTabBarController()
		
	}
	
}