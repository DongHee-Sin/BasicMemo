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



// MARK: - Realm List Test
final class Folder: Object {
    @Persisted var title: String
    @Persisted var imageString: String
    @Persisted var section: FolderSection
    
    @Persisted var memoList: List<Memo>
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    @Persisted var user: User?
    
    convenience init(title: String, imageString: String, section: FolderSection) {
        self.init()
        self.title = title
        self.imageString = imageString
        self.section = section
    }
}



// MARK: - Embedded Object Test
final class User: EmbeddedObject {
    @Persisted var name: String
    @Persisted var age: Int
}



enum FolderSection: String, PersistableEnum {
    case local
    case iCloud
}
