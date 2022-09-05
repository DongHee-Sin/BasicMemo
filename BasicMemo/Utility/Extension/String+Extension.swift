//
//  String+Extension.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/02.
//

import UIKit


extension String {
    
    var setMemoCellTitle: String {
        if self.trimmingCharacters(in: .whitespaces) != "" {
            return self
        }else {
            return "새로운 메모"
        }
    }
    
    
    
    var setMemoCellContent: String {
        if self.trimmingCharacters(in: .whitespaces) != "" {
            return self
        }else {
            return "추가 텍스트 없음"
        }
    }
    
    
    
    func changeColorSpecificText(text: String) -> NSMutableAttributedString {
        
        let range = (self as NSString).range(of: text, options: .caseInsensitive)

        let mutableAttributedString = NSMutableAttributedString.init(string: self)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemOrange, range: range)

        return mutableAttributedString
        
    }
    
}
