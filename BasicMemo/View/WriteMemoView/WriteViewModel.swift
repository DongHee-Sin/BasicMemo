//
//  WriteViewModel.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/04.
//

import UIKit


struct WriteViewModel {
    
    // MARK: - Propertys
    var repository = MemoDataRepository()
    
    var inputText: String = ""
    
    
    
    
    // MARK: - Methods
    func applyTextViewStyle() -> NSMutableAttributedString {
        let titleAttribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        let contentAttribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 15)
        ]
        
        let result = separatByEnter()
        
        let titleString = NSMutableAttributedString(string: result.title, attributes: titleAttribute)
        let contentString = NSMutableAttributedString(string: result.content, attributes: contentAttribute)
        
        titleString.append(contentString)
        
        return titleString
    }
    
    
    func processMemo(readMemo: Memo?) throws {
        guard let readMemo = readMemo else {
            try createMemo()
            return
        }

        if inputText == "" {
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
