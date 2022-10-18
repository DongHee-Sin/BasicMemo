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
    
    var folderCount: Int { folderList.count }
    var memoCount: Int { memoList.count }
    
    
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
    func fetchFolder(at index: Int) -> Folder {
        return folderList[index]
    }
    
    
    func folderCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Folder> {
        
        return UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.cell()
            
            content.text = itemIdentifier.title
            content.textProperties.numberOfLines = 1
            content.textProperties.font = .cellTitleFont
            
            content.image = UIImage(systemName: itemIdentifier.imageString)
            content.imageProperties.tintColor = .iconTint
            
            content.secondaryText = "\(itemIdentifier.memoList.count)"
            content.prefersSideBySideTextAndSecondaryText = true
            content.secondaryTextProperties.font = .secondaryTextFont
            content.secondaryTextProperties.color = .systemGray
            
            cell.accessories = [.disclosureIndicator()]
            
            cell.contentConfiguration = content
        })
        
    }
    
    
    func memoCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Memo> {
        
        return UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.cell()
            
            content.text = itemIdentifier.title
            content.textProperties.numberOfLines = 1
            content.textProperties.font = .cellTitleFont
            
            content.secondaryText = itemIdentifier.content
            content.prefersSideBySideTextAndSecondaryText = false
            content.secondaryTextProperties.font = .cellContentFont
            content.secondaryTextProperties.color = .systemGray
            
            cell.contentConfiguration = content
        })
        
    }
    
    
    func fetchMemoList(folder: Folder) -> Results<Memo> {
        return memoList.where {
            $0.folder == folder
        }
    }
}
