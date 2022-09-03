//
//  Memo.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/01.
//

import Foundation
import RealmSwift


final class Memo: Object {
    @Persisted var title: String
    @Persisted var content: String?
    @Persisted var savedDate: Date
    @Persisted var isSetPin: Bool

    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(title: String, content: String? = nil) {
        self.init()
        self.title = title
        self.content = content
        savedDate = Date()
        isSetPin = false
    }
}
