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


enum BackButtonTitle: String {
    case 메모
    case 검색
}


final class WriteMemoViewController: BaseViewController {

    // MARK: - Propertys
    var viewModel = WriteViewModel()
    
    var readMemo: Memo?
    
    var currentViewStatus: WriteViewControllerStatus? {
        didSet { viewStatusDidChanged() }
    }
    
    var backButtonTitle: BackButtonTitle = .메모
    
    private lazy var shareBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareBarButtonTapped))
    
    private lazy var finishBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonTapped))
    
    
    
    
    // MARK: - LifeCycle
    private let writeView = WriteView()
    override func loadView() {
        self.view = writeView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if currentViewStatus == .write {
            processMemo()
        }
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        writeView.textView.delegate = self
        
        updateTextView()
    }
    
    
    override func setNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.topItem?.title = backButtonTitle.rawValue
    }
    
    
    private func updateTextView() {
        guard let memo = readMemo, currentViewStatus == .read else { return }
        
        writeView.textView.text = "\(memo.title)\n\(memo.content ?? "")"
    }
    
    
    private func viewStatusDidChanged() {
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
    
    
    private func processMemo() {
        do {
            try viewModel.processMemo(readMemo: readMemo)
        }
        catch {
            showErrorAlert(error: error)
        }
    }
    
    
    @objc private func shareBarButtonTapped() {
        let activityViewController = UIActivityViewController(activityItems: [writeView.textView.text], applicationActivities: [])
        transition(activityViewController, transitionStyle: .present)
    }
    
    
    @objc private func finishButtonTapped() {
        currentViewStatus = .read
        processMemo()
    }
}




// MARK: - TextView Protocol
extension WriteMemoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if currentViewStatus == .read { currentViewStatus = .write }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.inputText = textView.text ?? ""
        
        textView.attributedText = viewModel.applyTextViewStyle()
    }
}
