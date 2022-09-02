//
//  UIViewController+Extension.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import UIKit


extension UIViewController {
    
    // MARK: - Alert
    typealias CompletionHandler = (UIAlertAction) -> Void
    
    func showAlert(title: String, buttonTitle: String = "확인", cancelTitle: String? = nil, completionHandler: CompletionHandler? = nil) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: buttonTitle, style: .default, handler: completionHandler)
        
        if let cancelTitle = cancelTitle {
            let cancelButton = UIAlertAction(title: cancelTitle, style: .destructive)
            alertController.addAction(cancelButton)
        }
        
        alertController.addAction(okButton)
        
        present(alertController, animated: true)
    }
    
    
    
    
    // MARK: - Transition ViewController
    enum TransitionStyle {
        case present
        case presentNavigation
        case presentFullNavigation
        case push
    }
    
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .present) {
        
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
        case .presentNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            self.present(navi, animated: true)
        case .presentFullNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
}
