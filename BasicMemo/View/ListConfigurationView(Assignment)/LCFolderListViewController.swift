//
//  LCFolderListViewController.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/10/18.
//

import UIKit

final class LCFolderListViewController: BaseViewController {

    // MARK: - Propertys
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Folder>!
    
    private let viewModel = LCListViewModel.shared
    
    
    
    
    // MARK: - Life Cycle
    let listView = LCListView()
    override func loadView() {
        self.view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        
    }
    
    
    private func setCollectionView() {
        listView.collectionView.collectionViewLayout = viewModel.collectionViewListLayout
        
        cellRegistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.cell()
            
            
            
            cell.accessories = [
                .checkmark(),
                .disclosureIndicator()
            ]
            
            cell.contentConfiguration = content
        })
    }
}
