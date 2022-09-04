//
//  WriteViewModel.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/04.
//

import Foundation


struct WriteViewModel {
    
    // MARK: - Propertys
    var repository = MemoDataRepository()
    
    
    
    
    // MARK: - Methods
    func applyTextViewStyle(text: String) {
        /*
         [didSet을 사용하여 textView의 텍스트가 변경될 때마다 적용하도록..하면 순환 문제가 발생하고]
         [텍스트 입력 -> 별도 변수에 저장 -> 변수에 didSet 적용... 해도 순환 문제 발생인데]
         [더 좋은 방법 생각해보기]
         
         1. \n 기준으로 제목과 내용을 분리
         2. 제목에만 글자크기와 폰트설정 변경
         3. 제목과 내용을 합쳐서 반환
         */
    }
    
    
    func separatByEnter(text: String) -> (title: String, content: String) {
        var separatedByEnter = text.components(separatedBy: "\n")
        let title = separatedByEnter.removeFirst()
        let content = separatedByEnter.joined(separator: "\n")
        
        return (title, content)
    }
    
    
    func saveMemo(text: String) throws {
        let result = separatByEnter(text: text)
        let memo = Memo(title: result.title, content: result.content)
        do {
            try repository.create(memo)
        }
        catch {
            throw error
        }
    }
}
