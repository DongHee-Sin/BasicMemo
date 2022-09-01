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
    var memoList: Results<Memo>
    var pinMemoList: Results<Memo>
    
    var memoCount: Int { memoList.count }
    var pinMemoCount: Int { pinMemoList.count }
    
    // Observer 토큰
    private var notificationToken: NotificationToken?
    
    
    
    // init
    init() {
        self.memoList = localRealm.objects(Memo.self).sorted(byKeyPath: "title", ascending: true).where {
            $0.isSetPin == false
        }
        
        self.pinMemoList = localRealm.objects(Memo.self).sorted(byKeyPath: "title", ascending: true).where {
            $0.isSetPin == true
        }
        
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
    
    
    
    // Read
    mutating private func fetchData() {
        self.memoList = localRealm.objects(Memo.self).sorted(byKeyPath: "title", ascending: true).where {
            $0.isSetPin == false
        }
        
        self.pinMemoList = localRealm.objects(Memo.self).sorted(byKeyPath: "title", ascending: true).where {
            $0.isSetPin == true
        }
    }
    
    
    func getMemo(at index: Int) -> Memo? {
        guard index < memoList.count else { return nil }
        return memoList[index]
    }
    
    
    func getPinMemo(at index: Int) -> Memo? {
        guard index < pinMemoList.count else { return nil }
        return pinMemoList[index]
    }
    
    
    
    // Update
    func update(at index: Int, section: Int, completion: (Memo) -> Void) throws {
        let dataToUpdate = section == 0 ? pinMemoList[index] : memoList[index]
        
        do {
            try localRealm.write({
                completion(dataToUpdate)
            })
        }
        catch {
            throw RealmError.updateError
        }
    }
    
    
    func memoPinToggle(at index: Int, section: Int) -> Bool {
        guard pinMemoCount < 5 || section == 0 else { return false }
        
        do {
            try update(at: index, section: section) { memo in
                memo.isSetPin.toggle()
            }
            return true
        }
        catch {
            return false
        }
    }
    
    
    
    // Delete
    func remove(at index: Int, section: Int) throws {
        let dataToDelete = section == 0 ? pinMemoList[index] : memoList[index]
        
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
    mutating func addObserver(section: Int, completion: @escaping () -> Void) {
        if section == 0 {
            notificationToken = pinMemoList.observe { _ in
                completion()
            }
        }else {
            notificationToken = memoList.observe { _ in
                completion()
            }
        }
    }
}
