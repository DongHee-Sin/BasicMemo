//
//  WriteMemoViewController.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/02.
//

import UIKit


protocol ManagingMemoDelegate {
    func saveMemo(title: String, content: String)
    
    func updateMemo(memo: Memo, title: String, content: String)
    
    func removeMemo(memo: Memo)
}


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
    var readMemo: Memo?
    
    var delegate: ManagingMemoDelegate?
    
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
            saveMemo()
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
    
    
    private func saveMemo() {
        guard writeView.textView.text != "" else {
            if let readMemo = readMemo {
                delegate?.removeMemo(memo: readMemo)
            }
            return
        }
        
        var separatedByEnter = writeView.textView.text.components(separatedBy: "\n")
        let title = separatedByEnter.removeFirst()
        let content = separatedByEnter.joined(separator: "\n")
        
        if let readMemo = readMemo {
            delegate?.updateMemo(memo: readMemo, title: title, content: content)
        }else {
            delegate?.saveMemo(title: title, content: content)
        }
    }
    
    
    @objc private func shareBarButtonTapped() {
        let activityViewController = UIActivityViewController(activityItems: [writeView.textView.text], applicationActivities: [])
        transition(activityViewController, transitionStyle: .present)
    }
    
    
    @objc private func finishButtonTapped() {
        currentViewStatus = .read
        saveMemo()
    }
}




// MARK: - TextView Protocol
extension WriteMemoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if currentViewStatus == .read { currentViewStatus = .write }
    }
}
