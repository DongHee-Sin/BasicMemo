//
//  WriteView.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/02.
//

import UIKit
import SnapKit


class WriteView: BaseView {
    
    // MARK: - Propertys
    let textView: UITextView = {
        let view = UITextView()
        view.font = .boldSystemFont(ofSize: 15)
        view.textColor = .label
        view.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        view.backgroundColor = .clear
        return view
    }()
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(textView)
    }
    
    
    override func setConstraint() {
        textView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
