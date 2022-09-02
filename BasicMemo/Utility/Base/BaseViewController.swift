//
//  BaseViewController.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setNavigationBar()
        
        setColor()
        setNavigationAppearance()
    }
    
    
    func configure() {}
    
    
    func setNavigationBar() {}
    
    
    private final func setColor() {
        view.backgroundColor = .background
        navigationController?.navigationBar.tintColor = .iconTint
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
    }
    
    
    private final func setNavigationAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .background
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
}
