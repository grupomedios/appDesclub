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
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0.0, 0.0)
    var radius: Double = 100.0
    var identifier: String = ""
    var eventType: kEventType = .onEntry
    
    var distance: CLLocationDistance = 0.0

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
    
    private func calculateDistance(currentLocation : CLLocation) {
        let discountLocation:CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.distance = discountLocation.distanceFromLocation(currentLocation)
    }

    
    class func loadNearPoints(currentLocation : CLLocation) -> [Geotification] {
        
        var allPoints = [Geotification]()
        
        if let json = Geotification.openJSONFile() {
            // print("jsonData:\(json)")
            if let arr = json as? NSArray {
                var index = 0
                
                for obj in arr {
                    let geo = Geotification(obj: obj as! [String : AnyObject])
                    geo.identifier = "\(index)"
                    geo.calculateDistance(currentLocation)
                    
                    index = index + 1
                    
                    allPoints.append(geo)
                }
                
                allPoints.sortInPlace { $0.distance > $1.distance }
                
                var nearPoint = [Geotification]()
                
                for i in 0..<20 {
                    nearPoint.append(allPoints[i])
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