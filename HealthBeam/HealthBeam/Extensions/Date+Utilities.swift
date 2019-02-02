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
}

extension DateFormatter {
    
    static let extendedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    static let simpleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter
    }()
}
