//
//  WriteViewModel.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/04.
//

import UIKit


struct WriteViewModel {
    
    // MARK: - Propertys
    var repository = MemoDataRepository.shared
    
    var inputText: String = ""
    
    private let fontSize = UIFont.textViewFont.pointSize
    private lazy var lineHeight = fontSize * 1.6
    
    private lazy var style: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        return style
    }()
    
    private let titleAttribute: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.label,
        .font: UIFont.textViewTitleFont
    ]
    
    private lazy var textViewAttribute: [NSAttributedString.Key: Any] = [
        .paragraphStyle: style,
        .foregroundColor: UIColor.label,
        .font: UIFont.textViewFont,
        .baselineOffset: (lineHeight - fontSize) / 4
    ]
    
    
    
    
    // MARK: - Methods
    mutating func applyTextViewStyle() -> NSAttributedString {
        let titleText = separatByEnter().title
        let titleRange = (titleText as NSString).range(of: titleText)
        
        let result = NSMutableAttributedString(
            string: inputText,
            attributes: textViewAttribute
        )
        
        result.setAttributes(titleAttribute, range: titleRange)
        
        return result
    }
    
    
    func processMemo(readMemo: Memo?) throws {
        guard let readMemo = readMemo else {
            try createMemo()
            return
        }

        if inputText.isEmpty {
            try removeMemo(memo: readMemo)
        }else {
            try updateMemo(memo: readMemo)
        }
    }
    
    
    private func separatByEnter() -> (title: String, content: String) {
        var separatedByEnter = inputText.components(separatedBy: "\n")
        let title = separatedByEnter.removeFirst()
        let content = separatedByEnter.joined(separator: "\n")
        
        return (title, content)
    }
    
    
    private func createMemo() throws {
        guard !inputText.isEmpty else { return }
        
        let result = separatByEnter()
        let memo = Memo(title: result.title, content: result.content)
        
        try repository.create(memo)
    }
    
    
    private func updateMemo(memo: Memo) throws {
        let result = separatByEnter()
        
        try repository.update(memo: memo) { memo in
            memo.title = result.title
            memo.content = result.content
            memo.savedDate = Date()
        }
    }
    
    
    private func removeMemo(memo: Memo) throws {
        try repository.remove(memo: memo)
    }
}
