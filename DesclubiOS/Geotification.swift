//
//  Geotification.swift
//  DesclubiOS
//
//  Created by Sergio Maturano on 26/9/16.
//  Copyright © 2016 Grupo Medios. All rights reserved.
//

import Foundation
import CoreLocation

enum kEventType {
    case onEntry
    case onExit
}


class Geotification: AnyObject {
    
    static let keyNotificationID = "identifier"

    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0.0, 0.0)
    var radius: Double = 200.0
    var identifier: String = ""
    var eventType: kEventType = .onEntry
    
    var distance: CLLocationDistance = 0.0
    
    private var dateShowed: NSDate?

    var name = ""
    var colonia = ""
    var cp = 0
    var address = ""
    var hours = ""
    var phone = ""
    var zone = ""

    init(obj: [String: AnyObject]) {
        
        self.name = obj["centro_comercial"] as! String
        self.colonia = obj["colonia"] as! String
        self.cp = obj["cp"] as! Int
        self.address = obj["domicilio"] as! String
        self.hours = obj["horario"] as! String
        self.phone = obj["telefono"] as! String
        self.zone = obj["zona"] as! String
        
        let lat = obj["latitud"] as! Double
        let long = obj["longitud"] as! Double
        
        self.coordinate = CLLocationCoordinate2DMake(lat, long)
        
    }
    
    private func loadDateShowed() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let key = "date_" + self.identifier
        
        if let date = userDefaults.objectForKey(key) as? NSDate{
            self.dateShowed = date
        }
    }
    
    func setDateShowed(date: NSDate) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let key = "date_" + self.identifier

        userDefaults.setObject(date, forKey: key)
        userDefaults.synchronize()
    }
    
    private func calculateDistance(currentLocation : CLLocation) {
        let discountLocation:CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.distance = discountLocation.distanceFromLocation(currentLocation)
    }

    class func getGotificationIdentifier(indentifier: String) -> Geotification? {
        
        if let index = Int(indentifier) {
            if let json = Geotification.openJSONFile() {
                // print("jsonData:\(json)")
                if let arr = json as? NSArray {
                    if let obj = arr[index] as? [String : AnyObject] {
                        let geo = Geotification(obj: obj)
                        geo.identifier = "\(index)"
                        return geo
                    }
                }
            }
        }
        
        return nil
        
    }
    
    
    class func loadNearPoints(currentLocation : CLLocation) -> [Geotification] {
        
        var allPoints = [Geotification]()
        
        if let json = Geotification.openJSONFile() {
            // print("jsonData:\(json)")
            if let arr = json as? NSArray {
                var index = 0
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let enableRules = userDefaults.boolForKey(CommonConstants.settingAdminRulesGeo)
                
                for obj in arr {
                    let geo = Geotification(obj: obj as! [String : AnyObject])
                    geo.identifier = "\(index)"
                    geo.loadDateShowed()
                    geo.calculateDistance(currentLocation)
                    
                    index = index + 1
                    
                    if enableRules {
                        // Ruler #1
                        // Show a time for week.
                        if let dateShowed = geo.dateShowed {
                            
                            let dateLimit = dateShowed.dateByAddingTimeInterval(60*60*24*7)
                            if dateLimit.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                                return [Geotification]()
                            }
                        }
                    }
                    
                    allPoints.append(geo)
                    
                }
                
                allPoints.sortInPlace { $0.distance > $1.distance }
                
                var nearPoint = [Geotification]()
                
                //print("Geofencing Points >>>>>>>>>")

                for i in 0..<20 {
                    let point = allPoints[i]
                    //print(point.coordinate)
                    nearPoint.append(point)
                }
                
                return nearPoint
            }
        }
     
        return [Geotification]()
    }
    
    class func openJSONFile() -> AnyObject? {
        
        if let path = NSBundle.mainBundle().pathForResource("geofencing", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                do {
                    let jsonObj = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                    return jsonObj
                } catch let error as NSError {
                    print(error.localizedDescription)
                    return nil
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
                return nil
            }
        } else {
            print("Invalid filename/path.")
            return nil
        }
    }
}