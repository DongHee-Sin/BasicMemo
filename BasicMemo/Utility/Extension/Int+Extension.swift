//
//  Int+Extension.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import Foundation


extension Int {
    
    var addComma: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: self))
        return result
    }
    
}
