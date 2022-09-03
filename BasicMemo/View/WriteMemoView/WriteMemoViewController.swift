//
//  WriteMemoViewController.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/02.
//

import UIKit


protocol SaveMemoDelegate {
    func saveMemo(title: String, content: String)
    
    func updateMemo(memo: Memo, title: String, content: String)
}


enum WriteViewControllerStatus {
    case write
    case read
}


final class WriteMemoViewController: BaseViewController {

    // MARK: - Propertys
    var readMemo: Memo?
    
    var delegate: SaveMemoDelegate?
    
    var currentViewStatus: WriteViewControllerStatus? {
        didSet { viewStatusDidChanged() }
    }
    
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
    
    
    
    
    // MARK: - Methods
    override func configure() {
        writeView.textView.delegate = self
        
        updateTextView()
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
    
    
    func updateTextView() {
        guard let memo = readMemo, currentViewStatus == .read else { return }
        
        writeView.textView.text = "\(memo.title)\n\(memo.content ?? "")"
    }
    
    
    func saveMemo() {
        var separatedByEnter = writeView.textView.text.components(separatedBy: "\n")
        let title = separatedByEnter.removeFirst()
        let content = separatedByEnter.joined(separator: "\n")
        
        if let readMemo = readMemo {
            delegate?.updateMemo(memo: readMemo, title: title, content: content)
        }else {
            delegate?.saveMemo(title: title, content: content)
        }
    }
    
    
    @objc func shareBarButtonTapped() {
        let activityViewController = UIActivityViewController(activityItems: ["공유할 문자열"], applicationActivities: [])
        transition(activityViewController, transitionStyle: .present)
    }
    
    
    @objc func finishButtonTapped() {
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
