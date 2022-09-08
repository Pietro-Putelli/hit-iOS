//
//  String+DateExtensions.swift
//  Hit
//
//  Created by Pietro Putelli on 28/10/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import Foundation

extension String {
    
    var yyyyMMddHHmmssZFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.locale = Locale(identifier: NSLocale.current.identifier)
        return dateFormatter
    }
    
    var dateStringHourMinute: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let date = yyyyMMddHHmmssZFormatter.date(from: self) else {
            return nil
        }
        return dateFormatter.string(from: date)
    }
    
    var dateStringYearMouthDay: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = yyyyMMddHHmmssZFormatter.date(from: self) else {
            return nil
        }
        return dateFormatter.string(from: date)
    }
    
    var dateDayMonth: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        
        if let date = yyyyMMddHHmmssZFormatter.date(from: self) {
            let stringDate = dateFormatter.string(from: date)
            if day(advanced: -1) {
                return "Yesterday"
            } else if day(advanced: 0) {
                return "Today"
            }
            return stringDate
        }
        return nil
    }
    
    func sameYear() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        guard let date = yyyyMMddHHmmssZFormatter.date(from: self) else {
            return false
        }
        return dateFormatter.string(from: date) == dateFormatter.string(from: Date())
    }
    
    func day(advanced by: Int = 0) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        guard let date = yyyyMMddHHmmssZFormatter.date(from: self) else {
            return false
        }
        let asDate = Date()
        
        let stringDayDate = dateFormatter.string(from: date)
        let stringDayAsDate = dateFormatter.string(from: asDate)
        
        dateFormatter.dateFormat = "yyyy"
        
        let stringYearDate = dateFormatter.string(from: date)
        let stringYearAsDate = dateFormatter.string(from: asDate)
        
        return (Int(stringDayDate)! == Int(stringDayAsDate)! + by) && stringYearDate == stringYearAsDate
    }
}

extension String {
    static var hours24Format: String = "yyyy-MM-dd HH:mm:ss Z"
    static var hours12Format: String = "yyyy-MM-dd h:mm:ss a Z"
    
    static var hours24Current: String {
        let components = Calendar.current.dateComponents([.year,.month,.day,.hour,.month,.second,.minute,.timeZone], from: Date())
        guard let date = Calendar.current.date(from: components) else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = .hours24Format
        dateFormatter.locale = Locale(identifier: NSLocale.current.identifier)
        return dateFormatter.string(from: date)
    }
    
    var currentHourFormat: Date? {
        let components = Calendar.current.dateComponents([.year,.month,.day,.hour,.month,.second,.minute,.timeZone], from: toDate!)
        guard let date = Calendar.current.date(from: components) else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = .hours24Format
        dateFormatter.locale = Locale(identifier: NSLocale.current.identifier)
        return date
    }
    
    var dateYearMonthDay: Date? {
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        
        if let date = currentHourFormat {
            return dateFormatter2.date(from: dateFormatter2.string(from: date))
        }
        return nil
    }
    
    var toDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = .hours24Format
        formatter.locale = Locale(identifier: NSLocale.current.identifier)
        return formatter.date(from: self)
    }
}

extension Date {
    var toString: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = .hours24Format
        formatter.locale = Locale(identifier: NSLocale.current.identifier)
        return formatter.string(from: self)
    }
}

extension Date {
    static var daysInWeek: Int {
        return 7 - 1
    }
    
    static var weeksInMonth: Int {
        return 4
    }
    
    static var monthsInYear: Int {
        return 12 - 1
    }
}

extension Date {
    func years(sinceDate: Date) -> String? {
        guard let delta = Calendar.current.dateComponents([.year], from: sinceDate, to: self).year else { return nil }
        return "\(delta)Y"
    }
    
    func months(sinceDate: Date) -> String? {
        guard let delta = Calendar.current.dateComponents([.month], from: sinceDate, to: self).month else { return nil }
        guard delta > Date.monthsInYear else { return "\(delta)M" }
        return years(sinceDate: sinceDate)
    }
    
    func weeks(sinceDate: Date) -> String? {
        guard let delta = Calendar.current.dateComponents([.weekOfMonth], from: sinceDate, to: self).weekOfMonth else { return nil }
        guard delta > Date.weeksInMonth else { return "\(delta)W" }
        return months(sinceDate: sinceDate)
    }
    
    func days(sinceDate: Date) -> String? {
        guard let delta = Calendar.current.dateComponents([.day], from: sinceDate, to: self).day else { return nil }
        guard delta > Date.daysInWeek else {
            switch delta {
            case 0: return "Today"
            case 1: return "Yesterday"
            default:
                return "\(delta)d"
            }
        }
        return weeks(sinceDate: sinceDate)
    }
}
