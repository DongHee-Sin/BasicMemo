//
//  BaseView.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import UIKit


class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func configureUI() {}
    
    func setConstraint() {}
}
