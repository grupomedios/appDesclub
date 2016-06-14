//
//  ImageExtensions.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 24/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

extension UIImage {
	func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		color.setFill()
		UIRectFill(CGRectMake(0, 0, 100, 100))
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
}