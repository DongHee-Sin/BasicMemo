//
//  PopUpView.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/03.
//

import UIKit


final class PopUpView: BaseView {
    
    // MARK: - Propertys
    private let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = .searchBarBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let welcomeTextLabel: UILabel = {
        let view = UILabel()
        view.text = """
        처음 오셨군요!
        환영합니다 :)
        
        당신만의 메모를 작성하고
        관리해보세요!
        """
        view.numberOfLines = 0
        view.textColor = .label
        view.font = .boldSystemFont(ofSize: 20)
        return view
    }()
    
    let okButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .systemYellow
        view.setTitle("확인", for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 20)
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    
    
    // MARK: - Methods
    override func configureUI() {        
        self.addSubview(popUpView)
        
        [welcomeTextLabel, okButton].forEach {
            popUpView.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        popUpView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(self.snp.width).multipliedBy(0.6)
        }
        
        welcomeTextLabel.snp.makeConstraints { make in
            make.top.equalTo(popUpView.snp.top).offset(12)
            make.horizontalEdges.equalTo(popUpView).inset(12)
        }
        
        okButton.snp.makeConstraints { make in
            make.top.equalTo(welcomeTextLabel.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(popUpView).inset(12)
            make.bottom.equalTo(popUpView.snp.bottom).offset(-12)
        }
    }
    
}
