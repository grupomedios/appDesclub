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
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation? = nil
    
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
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil))

		// Override point for customization after application launch.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        GoogleAnalitycUtil.setupGoogleAnalityc()
		Fabric.with([Crashlytics.self()])

		NavigationUtil.presentMainViewController()
        geofencingPush(launchOptions)
		
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
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setInteger(0, forKey: "NSUserDefaults")
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

}

extension AppDelegate: CLLocationManagerDelegate {
    
    //MARK:- Geofencing
    
    func handleEventForRegion(region: CLRegion!) {
        
        if let geotification = Geotification.getGotificationIdentifier(region.identifier) {
            
            let notificationString = "Descubre los descuentos que tienes en “\(geotification.name)” y sus alrededores con tu membresía Desclub!"
            
            if UIApplication.sharedApplication().applicationState != .Active {
                let notification = UILocalNotification()
                notification.userInfo = [Geotification.keyNotificationID: region.identifier]
                notification.alertBody = notificationString
                notification.soundName = "Default"
                
                let userDefault = NSUserDefaults.standardUserDefaults()
                var currentBadgeNumber = 0
                
                if let badgeNumber = userDefault.integerForKey("NSUserDefaults") as Int? {
                    currentBadgeNumber = badgeNumber
                }
                
                currentBadgeNumber = currentBadgeNumber + 1
                userDefault.setInteger(currentBadgeNumber, forKey: "NSUserDefaults")
                userDefault.synchronize()
                
                notification.applicationIconBadgeNumber = currentBadgeNumber

                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                
                geotification.setDateShowed(NSDate())
                
                self.stopMonitoring(geotification)
            }
            //        else {
            //            let alertController = UIAlertController(title: nil, message:
            //                notificationString, preferredStyle: UIAlertControllerStyle.Alert)
            //            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            //            window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            //
            //        }
            
        }
        
    }
    
    private func regionWithGeotification(geotification: Geotification) -> CLCircularRegion {
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func startMonitoring(geotification: Geotification) {
        
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion.self) {
            // Show error
            // Geofencing is not supported on this device!
            return
        }
        
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            // Show warning
            // "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location."
        }
        
        let region = self.regionWithGeotification(geotification)
        locationManager.startMonitoringForRegion(region)
        
    }
    
    func stopMonitoring(geotification: Geotification) {
        
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion else {
                continue
            }
            
            if circularRegion.identifier == geotification.identifier {
                locationManager.stopMonitoringForRegion(circularRegion)
            }
        }
    }
    
    func stopAllMonitoring() {
        
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion else {
                continue
            }
            
            locationManager.stopMonitoringForRegion(circularRegion)
        }
    }
    
    func geofencingPush(launchOptions: [NSObject: AnyObject]?) {
        
        if let op = launchOptions {
            if let not = op[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification{
                self.openPush(not.userInfo)
            }
        }
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        self.openPush(notification.userInfo)
    }
    
    func openPush(userInfo: [NSObject: AnyObject]?) {
        if let data = userInfo {
            if let id = data[Geotification.keyNotificationID] as? String {
                if let geotification = Geotification.getGotificationIdentifier(id) {
                    
                    //Search this CenterComercial
                    let category = FakeCategoryRepresentation(_id: "0", name: "Ver todas", image: "ver_todas", color: ColorUtil.allColor())
                    let discountsViewController = DiscountsViewController(nibName: "DiscountsViewController", bundle: nil, currentCategory: category)
                    print(geotification.identifier)
                    discountsViewController.searchString = ""
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.globalNavigationController.pushViewController(discountsViewController, animated: true)
                }
            }
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEventForRegion(region)
        }
    }
    
//    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
//        if region is CLCircularRegion {
//            handleEventForRegion(region)
//        }
//    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        locationManager.stopUpdatingLocation()
        
        if currentLocation == nil {
            currentLocation = newLocation
            self.loadPointGeo()
        }

    }
    
    func loadPointGeo() {
        
        self.stopAllMonitoring()
        
        let arr = Geotification.loadNearPoints(currentLocation!)
        for geo in arr {
            self.startMonitoring(geo)
        }
    }
}
