//
//  MemoListTableViewCell.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {

    // MARK: - Propertys
    let verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        view.distribution = .fillProportionally
        return view
    }()
    
    let horizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 17)
        view.textColor = .label
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = .subLabel
        return view
    }()
    
    let contentLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = .subLabel
        return view
    }()
    
    
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraint()
    }

    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    
    // MARK: - Methdos
    func configureUI() {
        self.addSubview(verticalStackView)
        
        [titleLabel, horizontalStackView].forEach {
            verticalStackView.addArrangedSubview($0)
        }
        
        [dateLabel, contentLabel].forEach {
            horizontalStackView.addArrangedSubview($0)
        }
    }
    
    
    func setConstraint() {
        
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        verticalStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.horizontalEdges.equalTo(self).inset(12)
        }
    }
    
    
    func updateCell(data: Memo) {
        titleLabel.text = data.title
        dateLabel.text = data.savedDate.formatted()
        contentLabel.text = data.content
    }
}
