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
    
    
    
    
    // MARK: - Error Alert
    func showErrorAlert(error: Error) {
        switch error {
        case RealmError.writeError: showAlert(title: "메모 저장에 실패했습니다.")
        case RealmError.updateError: showAlert(title: "메모 수정에 실패했습니다.")
        case RealmError.deleteError: showAlert(title: "메모 삭제에 실패했습니다.")
        default: showAlert(title: "에러가 발생했습니다.")
        }
    }
    
    
    
    
    // MARK: - Transition ViewController
    enum TransitionStyle {
        case present
        case presentOverFullScreen
        case push
    }
    
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle) {
        
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
        case .presentOverFullScreen:
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
}
