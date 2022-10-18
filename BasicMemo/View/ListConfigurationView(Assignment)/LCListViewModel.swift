//
//  LCListViewModel.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/10/18.
//

import UIKit
import RealmSwift


enum LCListType {
    case folder
    case memo
}


final class LCListViewModel {
    
    private init() {
        folderList = localRealm.objects(Folder.self)
        memoList = localRealm.objects(Memo.self)
    }
    
    // MARK: - Propertys
    static let shared = LCListViewModel()
    
    private let localRealm = try! Realm()
    
    private var folderList: Results<Folder>!
    private var memoList: Results<Memo>!
    
    
    private var collectionLayoutListConfiguration: UICollectionLayoutListConfiguration {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .background
        
        return configuration
    }
    
    
    var collectionViewListLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout.list(using: collectionLayoutListConfiguration)
        return layout
    }
    
    
    
    
    // MARK: - Methods
    func folderCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Folder> {
        
        return UICollectionView.CellRegistration(handler: { [weak self] cell, indexPath, itemIdentifier in
            guard let self = self else { return }
            
            var content = UIListContentConfiguration.cell()
            
            content.text = self.folderList[indexPath.item].title
            content.textProperties.numberOfLines = 1
            content.textProperties.font = .cellTitleFont
            
            
            
            cell.accessories = [
                .checkmark(),
                .disclosureIndicator()
            ]
            
            cell.contentConfiguration = content
        })
        
    }
}
