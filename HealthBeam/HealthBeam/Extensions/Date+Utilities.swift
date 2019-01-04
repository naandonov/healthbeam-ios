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
    
    func extendedDateString() -> String {
        return DateFormatter.extendedDateFormatter.string(from: self)
    }
}

extension DateFormatter {
    
    static let extendedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
}
