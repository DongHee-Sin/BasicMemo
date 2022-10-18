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
    
    private let resultTableViewController = SearchResultTableViewController(style: .insetGrouped)
    
    
    
    
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
        
        cellRegistration = viewModel.folderCellRegistration()
    }
    
    
    override func setNavigationBar() {
        navigationItem.title = "폴더"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setToolBarItem()
    }
    
    
    private func setToolBarItem() {
        self.navigationController?.isToolbarHidden = false
        
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let createFolderButton = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(createFolderButtonTapped))
        let writeMemoBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonTapped))
        
        createFolderButton.tintColor = .iconTint
        writeMemoBarButton.tintColor = .iconTint
        
        self.toolbarItems = [createFolderButton, flexibleSpaceItem, writeMemoBarButton]
    }
    
    
    @objc private func writeButtonTapped() {
        let vc = WriteMemoViewController()
        vc.currentViewStatus = .write
        transition(vc, transitionStyle: .push)
    }
    
    
    @objc private func createFolderButtonTapped() {
        print("createFolderButtonTapped")
    }
    
    
    private func setSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "검색"
        
        self.navigationItem.searchController = searchController
    }
}




// MARK: - CollectionView Protocol
extension LCFolderListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.folderCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let folder = viewModel.fetchFolder(at: indexPath.row)
        
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: folder)
        
        return cell
    }
}
