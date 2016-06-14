//
//  DiscountAnnotationView.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 2/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import UIKit
import MapKit

class DiscountAnnotationView: MKAnnotationView {
	
	// Required for MKAnnotationView
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
 
	// Called when drawing the DiscountAnnotationView
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		let discountAnnotation = self.annotation as! DiscountAnnotation
		
		if let category = discountAnnotation.discount.category {
			switch category._id! {
				
			case CommonConstants.CATEGORY_ALIMENTOS:
				image = UIImage(named: "alimentos")
			case CommonConstants.CATEGORY_BELLEZA_SALUD:
				image = UIImage(named: "belleza_salud")
			case CommonConstants.CATEGORY_EDUCACION:
				image = UIImage(named: "educacion")
			case CommonConstants.CATEGORY_ENTRETENIMIENTO:
				image = UIImage(named: "entretenimiento")
			case CommonConstants.CATEGORY_MODA_HOGAR:
				image = UIImage(named: "moda_hogar")
			case CommonConstants.CATEGORY_SERVICIOS:
				image = UIImage(named: "servicios")
			case CommonConstants.CATEGORY_TURISMO:
				image = UIImage(named: "turismo")
			default:
				image = UIImage(named: "ver_todas")
			}
			
			let size = CGSizeApplyAffineTransform(image!.size, CGAffineTransformMakeScale(0.2, 0.2))
			let hasAlpha = true
			let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
			
			UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
			image!.drawInRect(CGRect(origin: CGPointZero, size: size))
			
			let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			image = scaledImage
		}
	
	}
	
}
