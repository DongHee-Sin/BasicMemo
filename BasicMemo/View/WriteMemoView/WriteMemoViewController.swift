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
    var currentViewStatus: WriteViewControllerStatus? {
        didSet { viewStatusDidChanged() }
    }
    
    
    let shareBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareBarButtonTapped))
    let finishBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonTapped))
    
    
    
    
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
        writeView.textView.delegate = self
    }
    
    
    override func setNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    func viewStatusDidChanged() {
        guard let currentViewStatus = currentViewStatus else { return }
        switch currentViewStatus {
        case .write :
            writeView.textView.becomeFirstResponder()
            navigationItem.rightBarButtonItems = [finishBarButtonItem, shareBarButtonItem]
        case .read :
            writeView.textView.endEditing(true)
            navigationItem.rightBarButtonItems = [shareBarButtonItem]
        }
    }
    
    
    @objc func shareBarButtonTapped() {
        let activityViewController = UIActivityViewController(activityItems: ["공유할 문자열"], applicationActivities: [])
        transition(activityViewController, transitionStyle: .present)
    }
    
    
    @objc func finishButtonTapped() {
        currentViewStatus = .read
    }
}




// MARK: - TextView Protocol
extension WriteMemoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if currentViewStatus == .read { currentViewStatus = .write }
    }
}
