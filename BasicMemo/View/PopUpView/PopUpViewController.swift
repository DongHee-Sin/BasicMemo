//
//  PopUpViewController.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/03.
//

import UIKit

class PopUpViewController: BaseViewController {

    // MARK: - Life Cycle
    let popUpView = PopUpView()
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
    
    
    @objc func okButtonTapped() {
        UserDefaults.standard.set(true, forKey: "PopUp")
        dismiss(animated: true)
    }
}
