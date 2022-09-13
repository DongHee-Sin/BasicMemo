//
//  ReusableProtocol.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import UIKit


protocol ReusableProtocol {
    static var identifier: String { get }
}



extension UIViewController: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}


extension UITableViewCell: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}


extension UITableViewHeaderFooterView: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
