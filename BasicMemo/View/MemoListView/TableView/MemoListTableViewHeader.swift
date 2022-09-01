//
//  MemoListTableViewHeader.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import UIKit
import SnapKit


class MemoListTableViewHeader: UITableViewHeaderFooterView {

    // MARK: - Propertys
    let headerTitle: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 24, weight: .heavy)
        view.textColor = .label
        return view
    }()
    
    
    
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraint()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    
    
    // MARK: - Methods
    func configureUI() {
        self.addSubview(headerTitle)
    }
    
    
    func setConstraint() {
        headerTitle.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(20)
        }
    }

}
