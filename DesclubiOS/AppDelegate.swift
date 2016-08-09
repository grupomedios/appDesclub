//
//  AppDelegate.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 22/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	var globalNavigationController:UINavigationController!
	
	var tabBarController:UITabBarController!


	
	/**
	Builds the tab bar controller
	*/
	func buildTabBarController(){
		
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		
		tabBarController = UITabBarController()
		
		let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
		let mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
		let recommendedViewController = RecommendedViewController(nibName: "RecommendedViewController", bundle: nil)
		let cardViewController = CardViewController(nibName: "CardViewController", bundle: nil)
		
		
		mainViewController.tabBarItem = UITabBarItem(title: "Inicio", image: UIImage(named: "icon_home_off")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "icon_home")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
		mapViewController.tabBarItem = UITabBarItem(title: "Mapa", image: UIImage(named: "icon_map_off")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "icon_map")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
		recommendedViewController.tabBarItem = UITabBarItem(title: "Recomendados", image: UIImage(named: "icon_recommended_off")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "icon_recommended")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
		
		cardViewController.tabBarItem = UITabBarItem(title: "Tarjeta", image: UIImage(named: "icon_card_off")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "icon_card")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
		
		
		self.globalNavigationController = UINavigationController()
		
		
		let controllers = [mainViewController, mapViewController, recommendedViewController, cardViewController]
		
		tabBarController.viewControllers = controllers
		
		self.globalNavigationController.pushViewController(tabBarController, animated: true)
		
		window?.rootViewController = self.globalNavigationController
		
		window?.makeKeyAndVisible()
		
		desclubColoring()
	}
	
	/**
	Color elements with beepquest default colors
	*/
	func desclubColoring(){
		// colring tabs
		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: ColorUtil.desclubDarkGrayColor(), NSFontAttributeName: UIFont.systemFontOfSize(14)], forState:.Normal)
		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Selected)
		UITabBar.appearance().barTintColor = ColorUtil.desclubBlueColor()
		
		UINavigationBar.appearance().barTintColor = ColorUtil.desclubBlueColor()
		UINavigationBar.appearance().tintColor = UIColor.whiteColor()
		
		// Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/5 of the tabBar (if you have 4 items) and the height of the tabBar)
//		UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(ColorUtil.desclubBlueColor(), size: CGSizeMake(tabBarController.tabBar.frame.width/4, tabBarController.tabBar.frame.height))

	}
	
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
		// Override point for customization after application launch.
        
        GoogleAnalitycUtil.setupGoogleAnalityc()
		Fabric.with([Crashlytics.self()])

		NavigationUtil.presentMainViewController()
		
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

