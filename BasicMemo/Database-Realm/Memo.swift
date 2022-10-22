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

    @Persisted(originProperty: "memoList") var folder: LinkingObjects<Folder>
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(title: String, content: String) {
        self.init()
        self.title = title
        self.content = content
        self.memoDate = Date()
        self.isSetPin = false
    }
}
