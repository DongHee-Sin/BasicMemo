//
//  Folder.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/10/19.
//

import Foundation
import RealmSwift


enum FolderSection: String, PersistableEnum {
    case local
    case iCloud
}


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
