//
//  PopUpViewController.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/03.
//

import UIKit

final class PopUpViewController: BaseViewController {

    // MARK: - Life Cycle
    private let popUpView = PopUpView()
    override func loadView() {
        self.view = popUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        popUpView.okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private  func okButtonTapped() {
        UserDefaultManager.shared.isInitialLaunch = false
        dismiss(animated: true)
    }
}
