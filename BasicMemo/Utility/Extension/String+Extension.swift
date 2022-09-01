//
//  String+Extension.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/02.
//

import UIKit


extension String {
    
    func changeColorSpecificText(text: String) -> NSMutableAttributedString {
        
        let range = (self as NSString).range(of: text)

        let mutableAttributedString = NSMutableAttributedString.init(string: self)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemOrange, range: range)

        return mutableAttributedString
        
    }
    
}
