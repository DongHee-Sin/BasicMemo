//
//  Date+Extension.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/01.
//

import Foundation


extension Date {
    
    var format: String {
        let savedDate = self
        let currentDate = Date()
        
        let calendar = Calendar.current
        let dateDifference: Int = calendar.dateComponents([.day], from: savedDate, to: currentDate).day!
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        if dateDifference < 1 {
            dateFormatter.dateFormat = "a hh:mm"
        }else if dateDifference < 7 {
            dateFormatter.dateFormat = "E"
        }else {
            dateFormatter.dateFormat = "yyyy.MM.dd a hh:mm"
        }
        
        return dateFormatter.string(from: savedDate)
    }
    
}
