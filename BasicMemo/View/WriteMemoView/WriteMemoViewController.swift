//
//  WriteMemoViewController.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/02.
//

import UIKit


enum WriteViewControllerStatus {
    case write
    case read
}


class WriteMemoViewController: BaseViewController {

    // MARK: - Propertys
    var currentViewStatus: WriteViewControllerStatus = .write
    
    
    
    
    // MARK: - LifeCycle
    let writeView = WriteView()
    override func loadView() {
        self.view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        if currentViewStatus == .write {
            writeView.textView.becomeFirstResponder()
        }else {
            
        }
    }
    
    
    override func setNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        
        var rightBarButtonItems: [UIBarButtonItem] = []
        if currentViewStatus == .write {
            rightBarButtonItems.append(UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonTapped)))
        }
        rightBarButtonItems.append(UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(shareBarButtonTapped)))
        
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    
    
    @objc func shareBarButtonTapped() {
        let activityViewController = UIActivityViewController(activityItems: ["공유할 문자열"], applicationActivities: [])
        transition(activityViewController, transitionStyle: .present)
    }
    
    
    @objc func finishButtonTapped() {
    }
}
