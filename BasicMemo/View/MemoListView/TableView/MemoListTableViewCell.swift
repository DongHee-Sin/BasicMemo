//
//  MemoListTableViewCell.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {

    // MARK: - Propertys
    private let verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        view.distribution = .fillProportionally
        return view
    }()
    
    private let horizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .cellTitleFont
        view.textColor = .label
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.font = .cellContentFont
        view.textColor = .subLabel
        return view
    }()
    
    let contentLabel: UILabel = {
        let view = UILabel()
        view.font = .cellContentFont
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
    private func configureUI() {
        self.addSubview(verticalStackView)
        
        [titleLabel, horizontalStackView].forEach {
            verticalStackView.addArrangedSubview($0)
        }
        
        [dateLabel, contentLabel].forEach {
            horizontalStackView.addArrangedSubview($0)
        }
        
        selectionStyle = .none
    }
    
    
    private func setConstraint() {
        
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        verticalStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.horizontalEdges.equalTo(self).inset(12)
        }
    }
    
    
    func updateCell(data: Memo, keyword: String? = nil) {
        if let keyword = keyword {
            titleLabel.attributedText = data.title.changeColorSpecificText(text: keyword)
            contentLabel.attributedText = data.content?.changeColorSpecificText(text: keyword)
        }else {
            titleLabel.text = data.title
            contentLabel.text = data.content
        }
        
        dateLabel.text = DateFormatManager.shared.format(date: data.savedDate)
    }
}
