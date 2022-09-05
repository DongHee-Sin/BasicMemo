//
//  DateFormatManager.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/05.
//

import Foundation


final class DateFormatManager {
    
    static let shared = DateFormatManager()
    
    private init() {}
    
    
    private let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        calendar.locale = Locale.current
        return calendar
    }()
    
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }()
    
    
    func format(date: Date) -> String {
        let dateDifference: Int = calendar.dateComponents([.day], from: date, to: Date()).day!
        
        if dateDifference < 1 {
            dateFormatter.dateFormat = "a hh:mm"
        }else if calculateWeekNumberDifference(date: date) < 1 {
            dateFormatter.dateFormat = "E"
        }else {
            dateFormatter.dateFormat = "yyyy.MM.dd a hh:mm"
        }
        
        return dateFormatter.string(from: date) + "  "
    }
    
    
    private func calculateWeekNumberDifference(date: Date) -> Int {
        let weekNumberForStartDate = calendar.component(.weekOfYear, from: date)
        let weekNumberForEndDate = calendar.component(.weekOfYear, from: Date())

       let difference = weekNumberForEndDate - weekNumberForStartDate

       return difference
    }
}
