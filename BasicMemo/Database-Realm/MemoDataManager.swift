//
//  MemoDataManager.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/01.
//

import Foundation
import RealmSwift


enum RealmError: Error {
    case writeError
    case updateError
    case deleteError
}



struct MemoDataManager {
    
    private let localRealm = try! Realm()
    
    // Database Table
    var database: Results<Memo>
    
    var count: Int { database.count }
    
    // Observer 토큰
    private var notificationToken: NotificationToken?
    
    
    
    // init
    init() {
        self.database = localRealm.objects(Memo.self).sorted(byKeyPath: "title", ascending: true)
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    
    
    // Create(add)
    func write(_ memo: Memo) throws {
        do {
            try localRealm.write {
                localRealm.add(memo)
            }
        }
        catch {
            throw RealmError.writeError
        }
    }
    
    
    
    func getMemo(at index: Int) -> Memo? {
        guard index < database.count else { return nil }
        
        return database[index]
    }
    
    
    
    // Read
    mutating private func fetchData() {
        database = localRealm.objects(Memo.self).sorted(byKeyPath: "title", ascending: true)
    }
    
    
    
    // Update
    func update(at index: Int, completion: (Memo) -> Void) throws {
        let dataToUpdate = database[index]
        
        do {
            try localRealm.write({
                completion(dataToUpdate)
            })
        }
        catch {
            throw RealmError.updateError
        }
    }
    
    
    
    func memoPinToggle(at index: Int) -> Bool {
        guard count < 5 else { return false }
        
        do {
            try update(at: index) { memo in
                memo.isSetPin.toggle()
            }
            return true
        }
        catch {
            return false
        }
    }
    
    
    
    // Delete
    func remove(at index: Int) throws {
        let dataToDelete = database[index]
        
        do {
            try localRealm.write {
                localRealm.delete(dataToDelete)
            }
        }
        catch {
            throw RealmError.deleteError
        }
    }
    
    
    
    // Observer 달기
    mutating func addObserver(completion: @escaping () -> Void) {
        notificationToken = database.observe { _ in
            completion()
        }
    }
}
