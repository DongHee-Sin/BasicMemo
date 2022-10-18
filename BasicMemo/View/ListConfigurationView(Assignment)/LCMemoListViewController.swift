//
//  LCMemoListViewController.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/10/18.
//

import UIKit

final class LCMemoListViewController: BaseViewController {

    // MARK: - Propertys
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Memo>!
    
    private let viewModel = LCListViewModel.shared
    
    private let resultTableViewController = SearchResultTableViewController(style: .insetGrouped)
    
    var folder: Folder!
    
    private lazy var memoList = viewModel.fetchMemoList(folder: folder)
    
    
    
    
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
        setCollectionView()
        
        setSearchController()
    }
    
    
    private func setCollectionView() {
        listView.collectionView.delegate = self
        listView.collectionView.dataSource = self
        
        listView.collectionView.collectionViewLayout = viewModel.collectionViewListLayout
        
        listView.collectionView.contentInset = UIEdgeInsets(top: 12, left: .zero, bottom: .zero, right: .zero)
        
        cellRegistration = viewModel.memoCellRegistration()
    }
    
    
    override func setNavigationBar() {
        navigationItem.title = folder?.title ?? ""
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setToolBarItem()
    }
    
    
    private func setToolBarItem() {
        self.navigationController?.isToolbarHidden = false
        
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let writeMemoBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonTapped))
        
        writeMemoBarButton.tintColor = .iconTint
        
        self.toolbarItems = [flexibleSpaceItem, writeMemoBarButton]
    }
    
    
    @objc private func writeButtonTapped() {
        let vc = WriteMemoViewController()
        vc.currentViewStatus = .write
        transition(vc, transitionStyle: .push)
    }
    
    
    private func setSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "검색"
        
        self.navigationItem.searchController = searchController
    }
}




// MARK: - CollectionView Protocol
extension LCMemoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        memoList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let memo = memoList[indexPath.item]
        
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: memo)
        
        return cell
    }
}
