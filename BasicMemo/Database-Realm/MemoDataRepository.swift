//
//  MemoDataManager.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/01.
//

import UIKit
import RealmSwift


protocol MemoDataRepositoryType {
    func create(_ memo: Memo) throws
    
    func getMemo(at index: Int) -> Memo?
    func getPinMemo(at index: Int) -> Memo?
    
    func update(memo: Memo, completion: (Memo) -> Void) throws
    mutating func memoPinToggle(memo: Memo) -> Bool
    
    func remove(memo: Memo) throws
    
    mutating func addObserver(completion: @escaping () -> Void)
    
    mutating func fetchSearchResult(searchWord: String)
    func getSearchResult(at index: Int) -> Memo?
}


enum RealmError: Error {
    case writeError
    case updateError
    case deleteError
}


final class MemoDataRepository: MemoDataRepositoryType {
    
    // MARK: - Propertys
    static let shared = MemoDataRepository()
    
    private let localRealm = try! Realm()
    
    // Database Table
    private var totalMemoList: Results<Memo>
    private var memoList: Results<Memo>
    private var pinMemoList: Results<Memo>
    
    var totalMemoCount: Int { memoCount + pinMemoCount }
    var memoCount: Int { memoList.count }
    var pinMemoCount: Int { pinMemoList.count }
    
    // Observer 토큰
    private var memoNotificationToken: NotificationToken?
    
    
    // SearchController
    private var searchResultList: Results<Memo>?
    var searchResultCount: Int { searchResultList?.count ?? 0 }
    
    
    
    
    // MARK: - Init
    private init() {
        self.totalMemoList = localRealm.objects(Memo.self).sorted(byKeyPath: "memoDate", ascending: false)
        
        self.memoList = totalMemoList.where {
            $0.isSetPin == false
        }
        
        self.pinMemoList = totalMemoList.where {
            $0.isSetPin == true
        }
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    
    
    
    // MARK: - Methods
    // Create(add)
    func create(_ memo: Memo) throws {
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
    func getMemo(at index: Int) -> Memo? {
        guard index < memoCount else { return nil }
        return memoList[index]
    }
    
    
    func getPinMemo(at index: Int) -> Memo? {
        guard index < pinMemoCount else { return nil }
        return pinMemoList[index]
    }
    
    
    
    // Update
    func update(memo: Memo, completion: (Memo) -> Void) throws {
        do {
            try localRealm.write({
                completion(memo)
            })
        }
        catch {
            throw RealmError.updateError
        }
    }
    
    
    func memoPinToggle(memo: Memo) -> Bool {
        guard pinMemoCount < 5 || memo.isSetPin else { return false }
        
        do {
            try update(memo: memo) { memo in
                memo.isSetPin.toggle()
            }
            return true
        }
        catch {
            return false
        }
    }
    
    
    
    // Delete
    func remove(memo: Memo) throws {
        do {
            try localRealm.write {
                localRealm.delete(memo)
            }
        }
        catch {
            throw RealmError.deleteError
        }
    }
    
    
    
    // Observer 달기
    func addObserver(completion: @escaping () -> Void) {
        memoNotificationToken = totalMemoList.observe { _ in
            completion()
        }
    }
    
    
    
    // SearchController
    func fetchSearchResult(searchWord: String) {
        searchResultList = totalMemoList.where {
            $0.title.contains(searchWord, options: .caseInsensitive) || $0.content.contains(searchWord, options: .caseInsensitive)
        }
    }
    
    func getSearchResult(at index: Int) -> Memo? {
        guard index < searchResultCount else { return nil }
        return searchResultList?[index]
    }
}
