//
//  ReusableProtocol.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import UIKit


public protocol ReusableProtocol {
    static var identifier: String { get }
}



extension UIViewController: ReusableProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}


extension UICollectionViewCell: ReusableProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}


extension UITableViewCell: ReusableProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}


extension UITableViewHeaderFooterView: ReusableProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}
