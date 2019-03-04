//
//  Date+Utilities.swift
//  App
//
//  Created by Nikolay Andonov on 15.12.18.
//

import Foundation

extension Date {
    
    static func dateFromExtendedDateString(_ dateString: String) -> Date? {
        return DateFormatter.extendedDateFormatter.date(from: dateString)
    }
    
    func simpleDateString() -> String {
        return DateFormatter.simpleDateFormatter.string(from: self)
    }
    
    func extendedDateString() -> String {
        return DateFormatter.extendedDateFormatter.string(from: self)
    }
    
    func yearsSince() -> String {
        return "\(Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0)"
    }
    
    func passedTime() -> String? {
        let difference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self, to: Date())
        
        guard let days = difference.day, let hours = difference.hour, let minutes = difference.minute, let seconds = difference.second else {
            return nil
        }
        
        var output: String
        if days > 0 {
            output = "\(days)" + " " + (days == 1 ? "day".localized() : "days".localized())
        } else if hours > 0 {
            output = "\(hours)" + " " + (hours == 1 ?  "hour".localized() : "hours".localized())
        } else if minutes > 0 {
            output = "\(minutes)" + " " + (minutes == 1 ?  "minute".localized() : "minutes".localized())
        } else {
            output = "\(seconds)" + " " + (seconds == 1 ?  "second".localized() : "seconds".localized())
        }
        output += " ago".localized()
        
        return output
    }
}

extension DateFormatter {
    
    static let extendedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    static let simpleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
}
