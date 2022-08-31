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
    let tableView: UITableView = {
        let view = UITableView(frame: CGRect(), style: .insetGrouped)
        view.backgroundColor = .clear
        return view
    }()
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [tableView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
