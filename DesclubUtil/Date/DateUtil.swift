//
//  DateUtil.swift
//  BeepQuest
//
//  Created by Jhon Cruz on 16/04/15.
//  Copyright (c) 2015 GQuest. All rights reserved.
//

import Foundation

final class DateUtil {
	
	static func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
		let calendar = NSCalendar.currentCalendar()
		let now = NSDate()
		let earliest = now.earlierDate(date)
		let latest = (earliest == now) ? date : now
		let components:NSDateComponents = calendar.components([.Minute, .Hour, .Day , .WeekOfYear , .Month , .Year , .Second], fromDate: earliest, toDate: latest, options: [])
		
		if (components.year >= 2) {
			return "hace \(components.year) años"
		} else if (components.year >= 1){
			if (numericDates){
				return "hace 1 año"
			} else {
				return "el año pasado"
			}
		} else if (components.month >= 2) {
			return "hace \(components.month) meses"
		} else if (components.month >= 1){
			if (numericDates){
				return "hace 1 mes"
			} else {
				return "el mes pasado"
			}
		} else if (components.weekOfYear >= 2) {
			return "hace \(components.weekOfYear) semanas"
		} else if (components.weekOfYear >= 1){
			if (numericDates){
				return "hace 1 semana"
			} else {
				return "la semana pasada"
			}
		} else if (components.day >= 2) {
			return "hace \(components.day) días"
		} else if (components.day >= 1){
			if (numericDates){
				return "hace 1 día"
			} else {
				return "ayer"
			}
		} else if (components.hour >= 2) {
			return "hace \(components.hour) horas"
		} else if (components.hour >= 1){
			if (numericDates){
				return "hace 1 hora"
			} else {
				return "hace 1 hora"
			}
		} else if (components.minute >= 2) {
			return "hace \(components.minute) minutos"
		} else if (components.minute >= 1){
			if (numericDates){
				return "hace 1 minuto"
			} else {
				return "hace 1 minuto"
			}
		} else if (components.second >= 3) {
			return "hace \(components.second) segundos"
		} else {
			return "ahora"
		}
		
	}
	
}