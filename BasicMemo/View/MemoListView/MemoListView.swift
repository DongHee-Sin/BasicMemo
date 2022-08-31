//
//  MemoListView.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import UIKit
import SnapKit


final class MemoListView: BaseView {
    
    // MARK: - Propertys
    let test: UILabel = {
        let view = UILabel()
        view.text = "absdfsad"
        view.textColor = .label
        return view
    }()
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [test].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        test.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
}
