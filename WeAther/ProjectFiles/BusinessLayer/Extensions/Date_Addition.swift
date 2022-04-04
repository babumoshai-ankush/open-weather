//
//  Date+Extension.swift
//  eSehati
//
//  Created by Redapple090 on 06/03/20.
//  Copyright © 2020 Redapple090. All rights reserved.
//

import Foundation

enum DateFormat: String {
    case dayName = "EEEE"
    case hour = "h a"
    case hourMinute = "h:mm a"
}

extension Date {
    func getString(format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    
    var isHourSame: Bool {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let checkWith = dateFormatter.string(from: self)
        let nowHour = dateFormatter.string(from: now)
        return checkWith == nowHour
    }
    
    var dayName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
