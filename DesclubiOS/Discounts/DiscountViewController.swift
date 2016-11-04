//
//  DiscountViewController.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 3/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit
import MapKit

class DiscountViewController: AbstractLocationViewController, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate, UIAdaptivePresentationControllerDelegate {

	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var childView: UIView!
	@IBOutlet weak var discountImage: UIImageView!
	@IBOutlet weak var discountText: UILabel!
	@IBOutlet weak var cash: UILabel!
	@IBOutlet weak var cashText: UILabel!
	@IBOutlet weak var card: UILabel!
	@IBOutlet weak var cardText: UILabel!
	@IBOutlet weak var promo: UILabel!
	@IBOutlet weak var validityEnd: UILabel!
	@IBOutlet weak var branchName: UILabel!
	@IBOutlet weak var branchAddress: UILabel!
	@IBOutlet weak var restriction: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var btnPhone: UIButton!
	@IBOutlet weak var discountButton: UIView!
	
	var actionButton: ActionButton!
	
	
	private var discount:DiscountRepresentation?
	
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
        setDiscountData()

    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
        GoogleAnalitycUtil.trackScreenName("analytics.screen.discount")
        
        if let name = self.discount?.branchName() {
            let event = "Descuento - " + name
            GoogleAnalitycUtil.trackEvent("analytics.category.discount", event: event)
        }
        
		setupCurrentView()
		// setDiscountData()
    
	}
	
	/**
	Returns the distance in meters from the current position to the discount
	
	*/
	private func calculateDistance()->CLLocationDistance {
		if let coordinates = self.discount?.location?.coordinates {
			
			let discountLocation:CLLocation = CLLocation(latitude: coordinates[1], longitude: coordinates[0])
			
			let locationDistance:CLLocationDistance = discountLocation.distanceFromLocation(currentLocation)
			
			return locationDistance
			
		}
		
		return -1
	}
	
	private func calculateDistanceString()->String {
		
		let locationDistance:CLLocationDistance = self.calculateDistance()
		
		let formatter = NSNumberFormatter()
		formatter.numberStyle = .DecimalStyle
		formatter.maximumFractionDigits = 2
		
		if locationDistance < 1000 {
			return formatter.stringFromNumber(locationDistance)! + " m"
		}else{
			return formatter.stringFromNumber(locationDistance / 1000)! + " km"
		}
	}
    
    @IBAction func callPhone() {
        if let discount = self.discount {
            if let phone = discount.branch?.phone {
                if let url = NSURL(string: "telprompt://" + phone) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
        }
    }
	
	private func setDiscountData(){
		
		if let discount = self.discount {
			
			
			if let branch:BranchRepresentation = discount.branch {
				self.branchName.text = discount.branch?.name
				self.branchAddress.text = branch.getCompleteAddress()
			}
            
            self.lblPhone.text = ""
            self.btnPhone.hidden = true
            self.cash.text = "\(0)%"
            self.card.text = "\(0)%"
            
            if let phone = discount.branch?.phone {
                if phone.characters.count > 0 {
                    self.btnPhone.hidden = false
                    self.lblPhone.text = "Teléfono: " + phone
                }
            }
            
            if let cash = discount.cash {
                if !cash.isEmpty{
                    self.cash.text = "\(cash)%"
                }
            }
            
            if let card = discount.card {
                if !card.isEmpty{
                    self.card.text = "\(card)%"
                }
            }
            
            self.promo.text = discount.promo
			
			if let validityEnd = discount.brand?.validity_end {
				let formatter = NSDateFormatter()
				formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
				formatter.dateFormat = CommonConstants.readableDateFormat
				let dateString = formatter.stringFromDate(validityEnd)
				self.validityEnd.text = "Vigente hasta: \(dateString)"
			}
			self.restriction.text = discount.restriction
			
			//show logo image
			if discount.brand?.logoSmall != nil {
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
			
			
			//handle tap
			let tap = UITapGestureRecognizer(target: self, action: #selector(DiscountViewController.discountTap))
			tap.delegate = self
			discountButton.addGestureRecognizer(tap)
			
			
			//action buttons
			let useCouponImage = UIImage(named: "checked")!
			let checkMapImage = UIImage(named: "map")!
			let checkBranchesImage = UIImage(named: "similar")!
			let checkPathImage = UIImage(named: "map_path")!
			
			let useCoupon = ActionButtonItem(title: "Usar cupón", image: useCouponImage)
			useCoupon.action = { item in
				self.useCoupon()
				self.actionButton.toggleMenu()
			}
			
			let checkMap = ActionButtonItem(title: "Ver en mapa", image: checkMapImage)
			checkMap.action = { item in

				let searchMapViewController = SearchMapViewController(nibName: "SearchMapViewController", bundle: nil, currentLocation:CLLocation(latitude: 0.0, longitude: 0.0), searchId: self.discount!._id!, searchString: "", searchState: nil, searchZone: nil, searchCategory: nil, searchSubcategory: nil)
				
				let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
				appDelegate.globalNavigationController.presentViewController(searchMapViewController, animated: true, completion:nil)
				
				self.actionButton.toggleMenu()
				
			}
			
			let checkBranches = ActionButtonItem(title: "Ver sucursales", image: checkBranchesImage)
			checkBranches.action = { item in
				
				let discountBranchViewController = BranchesViewController(nibName: "BranchesViewController", bundle: nil, discount:self.discount!)
				let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
				appDelegate.globalNavigationController.pushViewController(discountBranchViewController, animated: true)
				
				self.actionButton.toggleMenu()
				
			}
			
			let checkPath = ActionButtonItem(title: "Cómo llegar", image: checkPathImage)
			checkPath.action = { item in
				
				if let location = self.discount?.location {
					if let coordinates = location.coordinates {
						let lat:Double = coordinates[1]
						let lon:Double = coordinates[0]
						self.openMapForPlace(lat, lon: lon)
					}
				}
				
				self.actionButton.toggleMenu()
				
			}
			
			actionButton = ActionButton(attachedToView: self.view, items: [useCoupon, checkMap, checkBranches, checkPath])
			actionButton.action = { button in button.toggleMenu() }
		}
	
	}
	
	func discountTap() {
		useCoupon()
	}
	
    func useCoupon() {
        
        if let name = self.discount?.branchName() {
            let event = "Cupon - " + name
            GoogleAnalitycUtil.trackEvent("analytics.category.coupon", event: event)
        }
        
        if calculateDistance() > 2000 {
			
			let alertController = UIAlertController(title: "¡Fuera de rango!", message:
    "Debes estar cerca del establecimiento para usar este cupón", preferredStyle: UIAlertControllerStyle.Alert)
			alertController.addAction(UIAlertAction(title: "Entendido", style: UIAlertActionStyle.Default,handler: nil))
			
			self.presentViewController(alertController, animated: true, completion: nil)

			
		}else{
				
//			let cardPopoverViewController:CardPopoverViewController = CardPopoverViewController(nibName: "CardPopoverViewController", bundle: nil, discount: self.discount!)
//			cardPopoverViewController.modalPresentationStyle = .Popover
//			cardPopoverViewController.preferredContentSize = CGSizeMake(429, 271)
//			
//			
//			//configure it
//			if let popoverController = cardPopoverViewController.popoverPresentationController {
//				popoverController.sourceView = discountButton
//				popoverController.sourceRect = discountButton.bounds
//				popoverController.permittedArrowDirections = .Any
//				popoverController.delegate = self
//			}
//			
//			// Present it
//			presentViewController(cardPopoverViewController, animated: true, completion: nil)
            
            let vc = VoucherViewController(nibName: "VoucherViewController", bundle: nil, discount: self.discount!)
            self.navigationController?.pushViewController(vc, animated: true)
			
		}
	}
	
	func openMapForPlace(lat:Double, lon:Double) {
		
		let latitute:CLLocationDegrees =  lat
		let longitute:CLLocationDegrees =  lon
		
		let regionDistance:CLLocationDistance = 10000
		let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
		let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
		let options = [
			MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
			MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span),
			MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving
		]
		let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
		let mapItem = MKMapItem(placemark: placemark)
		if let branch = self.discount?.branch {
			mapItem.name = "\(branch.name!)"
		}
		mapItem.openInMapsWithLaunchOptions(options)
		
	}
	
	private func setupCurrentView(){
		
		self.edgesForExtendedLayout = UIRectEdge.None
		self.navigationController?.navigationBar.translucent = false
		self.navigationController?.setNavigationBarHidden(false, animated: true)
		self.title = self.discount?.branch?.name
		
		//change nav bar color and tint color
		let bar:UINavigationBar! =  self.navigationController?.navigationBar
		let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(13.0)]
		bar.titleTextAttributes = titleDict as? [String : AnyObject]
		bar.barTintColor = ColorUtil.desclubBlueColor()
		bar.shadowImage = UIImage()
		bar.tintColor = UIColor.whiteColor()
		
		UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(13.0)], forState: UIControlState.Normal)
		
	}
	
	/**
	// MARK: - CoreLocation
	
	Core location listener for updated location
	*/
	func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
		self.currentLocation = newLocation
		if let discount = self.discount {
			if let branch:BranchRepresentation = discount.branch {
				self.branchAddress.text = branch.getCompleteAddress() + "  (" + calculateDistanceString() + ")"
			}
		}
	}
	
	/**
	Core location error listener
	*/
	func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
		self.currentLocation = CLLocation(latitude: CommonConstants.defaultLatitude, longitude: CommonConstants.defaultLongitude)
	}

	
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.None
	}

}
