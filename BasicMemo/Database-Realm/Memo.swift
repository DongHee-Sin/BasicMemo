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
    @Persisted var content: String
    @Persisted var memoDate: Date
    @Persisted var isSetPin: Bool
    @Persisted var test: Double
    @Persisted var test2: Double
    @Persisted var mixValue: Double

    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(title: String, content: String) {
        self.init()
        self.title = title
        self.content = content
        memoDate = Date()
        isSetPin = false
        test2 = 7.7
        mixValue = test + test2
    }
}
