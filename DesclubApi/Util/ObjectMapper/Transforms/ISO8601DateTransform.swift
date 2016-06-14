//
//  ISO8601DateTransform.swift
//  ObjectMapper
//
//  Created by Jean-Pierre Mouilleseaux on 21 Nov 2014.
//
//

import Foundation

public class ISO8601DateTransform: DateFormaterTransform {

	public init() {
		let formatter = NSDateFormatter()
		formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
		formatter.dateFormat = CommonConstants.dateFormat
		
		super.init(dateFormatter: formatter)
	}
	
}
