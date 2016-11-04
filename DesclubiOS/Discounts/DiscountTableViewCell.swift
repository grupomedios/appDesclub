//
//  DiscountTableViewself.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 29/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit

class DiscountTableViewCell: UITableViewCell {

	
	@IBOutlet weak var discountImage: UIImageView!
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var address: UILabel!
	@IBOutlet weak var distance: UILabel!
	@IBOutlet weak var percentagesContainer: UIView!
	@IBOutlet weak var lblCenter: UILabel!
	@IBOutlet weak var cash: UILabel!
	@IBOutlet weak var card: UILabel!
	
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithDiscount(discount: DiscountRepresentation, colorCategory: UIColor = ColorUtil.desclubBlueColor(), distance: Double = -1) {
        
        self.name.text = discount.branch?.name
        self.distance.text = calculateDistance(distance)
        self.distance.textColor = colorCategory
        self.distance.sizeToFit()


        if let branch:BranchRepresentation = discount.branch {
            self.address.text = branch.getCompleteAddress()
            self.address.sizeToFit()
        }
        
        self.cash.hidden = true
        self.card.hidden = true
        self.lblCenter.hidden = true
        
        if let cash = discount.cash {
            if !cash.isEmpty{
                self.cash.text = "\(cash)%"
                self.cash.hidden = false
            }
        }
        
        if let card = discount.card {
            if !card.isEmpty{
                self.card.text = "\(card)%"
                self.card.hidden = false
            }
        }
        
        if self.cash.hidden && self.card.hidden {
            
            // Show promo
            self.lblCenter.text = "Promoción"
            self.lblCenter.hidden = false
            
        }else if self.cash.hidden == false && self.card.hidden == true {

            // Show Cash center
            self.lblCenter.text = self.cash.text
            self.lblCenter.hidden = false
            self.cash.hidden = true

        }else if self.card.hidden == false && self.cash.hidden == true {

            // Show Card center
            self.lblCenter.text = self.card.text
            self.lblCenter.hidden = false
            self.card.hidden = true

        }
        
        self.percentagesContainer.backgroundColor = colorCategory
        
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
        
    }
    
    private func calculateDistance(distanceInKm:Double) -> String{
        
        if distanceInKm == -1 {
            return ""
        }
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = 2
        
        if distanceInKm < 1 {
            return formatter.stringFromNumber(distanceInKm * 1000)! + " m"
        }else{
            return formatter.stringFromNumber(distanceInKm)! + " km"
        }
    }
}
