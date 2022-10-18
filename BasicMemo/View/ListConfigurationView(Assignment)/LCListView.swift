//
//  LCListView.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/10/18.
//

import UIKit


final class LCListView: BaseView {
    
    // MARK: - Propertys
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: LCListViewModel.shared.collectionViewListLayout)
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(collectionView)
    }
    
    
    override func setConstraint() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
