//
//  UserHelper.swift
//  BeepQuest
//
//  Created by Jhon Cruz on 12/03/15.
//  Copyright (c) 2015 GQuest. All rights reserved.
//

import Foundation

/// User helper class for managing session specific variables
struct UserHelper {
	
	static let currentUserKey:String = "BeepCurrentUser"
	static let membershipModalShown:String = "membershipModalShown"
	
	/**
	Check if user is logged in or not
	
	:returns:	if the user is logged in
	*/
	static func isLoggedIn() -> Bool {
		
		if let currentUser = getCurrentUser() {
			
			if currentUser._id != nil && !currentUser._id!.isEmpty && currentUser.membershipNumber != nil && !currentUser.membershipNumber!.isEmpty {
				return true
			}
		}
		
		return false
	}
	
	/**
	Check if user is salud
	
	:returns:	if the user is logged in
	*/
	static func isSalud() -> Bool {
		
		if let currentUser = getCurrentUser() {
			
			if let membershipNumber = currentUser.membershipNumber{
				
				if !membershipNumber.isEmpty && membershipNumber[membershipNumber.startIndex.advancedBy(6)] == "1"{
					return true
				}
			}
		}
		
		return false
	}
	
	/**
	Logouts the user from application by removing all NSUserDefaults
	*/
	static func logout(){
		let appDomain = NSBundle.mainBundle().bundleIdentifier
		NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
	}
	
	/**
	get preferences
	
	:returns: the default preferences
	*/
	static func getPrefs() -> NSUserDefaults {
		return NSUserDefaults.standardUserDefaults()
	}
	
	/**
	saves a user into preferences
	
	:param:	guest	the user to be saved
	*/
	static func setCurrentUser(guest:CorporateMembershipRepresentation){
		
		let prefs:NSUserDefaults = getPrefs()
		
		let guestObj:AnyObject = Mapper().toJSON(guest)
		
		prefs.setObject(guestObj, forKey: currentUserKey)
	}
	
	/**
	returns the current logged in user
	
	:returns: thre current logged in user
	*/
	static func getCurrentUser() -> CorporateMembershipRepresentation? {
		let prefs:NSUserDefaults = getPrefs()
		if let rawGuest: AnyObject = prefs.objectForKey(currentUserKey) {
			magic(rawGuest)
			let guest = Mapper<CorporateMembershipRepresentation>().map(rawGuest)
			
			return guest
		}
		
		return nil
		
	}
	
	/**
	returns the formated card/membership number e.g. 0000 0000 0000 0000
	
	:returns: the formated card number of the current user
	*/
	static func getCardNumber() -> String{
		let membership:CorporateMembershipRepresentation = UserHelper.getCurrentUser()!
		
		var cardNumberReturn = "0000 0000 0000 0000"
		
		if let cardNumber = membership.membershipNumber {
			var formattedCardNumber:String = ""
			formattedCardNumber = cardNumber.substringWithRange(Range<String.Index>(start: cardNumber.startIndex.advancedBy(0), end: cardNumber.startIndex.advancedBy(4)))
			formattedCardNumber = formattedCardNumber + "  " + cardNumber.substringWithRange(Range<String.Index>(start: cardNumber.startIndex.advancedBy(4), end: cardNumber.startIndex.advancedBy(8)))
			formattedCardNumber = formattedCardNumber + "  " + cardNumber.substringWithRange(Range<String.Index>(start: cardNumber.startIndex.advancedBy(8), end: cardNumber.startIndex.advancedBy(12)))
			formattedCardNumber = formattedCardNumber + "  " + cardNumber.substringWithRange(Range<String.Index>(start: cardNumber.startIndex.advancedBy(12), end: cardNumber.startIndex.advancedBy(16)))
			
			cardNumberReturn = formattedCardNumber
		}
		
		return cardNumberReturn
	}
	
	/**
	returns the formated card/membership number e.g. 0000 0000 0000 0000
	
	:returns: the formated card number of the current user
	*/
	static func getSaludNumber() -> String{
		let membership:CorporateMembershipRepresentation = UserHelper.getCurrentUser()!
		
		var cardNumberReturn = "0000000"
		
		if let cardNumber = membership.membershipNumber {
			var formattedCardNumber:String = ""
			formattedCardNumber = formattedCardNumber + "" + cardNumber.substringWithRange(Range<String.Index>(start: cardNumber.startIndex.advancedBy(9), end: cardNumber.startIndex.advancedBy(16)))
			
			cardNumberReturn = formattedCardNumber
		}
		
		return cardNumberReturn
	}
	
	/**
	returns the formated valid thru e.g. 0000 0000 0000 0000
	
	:returns: the formated valid thru of the current user
	*/
	static func getValidThru() ->String {
		
		let membership:CorporateMembershipRepresentation = UserHelper.getCurrentUser()!
		
		var validThruReturn = "00-15"
		
		let validThruFormatter = NSDateFormatter()
		validThruFormatter.dateFormat = "M-YY"
		
		if let validThruVal = membership.validThru{
			validThruReturn = validThruFormatter.stringFromDate(validThruVal)
		}else{
			if let created = membership.created{
				validThruReturn = validThruFormatter.stringFromDate(created.dateByAddingTimeInterval(60*60*24*365))
			}else{
				validThruReturn = validThruFormatter.stringFromDate(NSDate().dateByAddingTimeInterval(60*60*24*30))
			}
		}
		
		return validThruReturn
	}
	
	/**
	saves the flag time since last modal shown
	
	:param:	modalShown	time since last modal shown (time millis)
	*/
	static func setTimeSinceLastLogin(modalShown:Double) {
		let prefs:NSUserDefaults = getPrefs()
		prefs.setDouble(modalShown, forKey: membershipModalShown)
	}
	
	/**
	returns the flag time since last modal shown
	
	:returns: time since last modal shown (time millis)
	*/
	static func getTimeSinceLastLogin() -> Double {
		let prefs:NSUserDefaults = getPrefs()
		return prefs.doubleForKey(membershipModalShown)
	}
	
}