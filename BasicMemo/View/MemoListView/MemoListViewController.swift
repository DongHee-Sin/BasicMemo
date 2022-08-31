//
//  MemoListViewController.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import UIKit

final class MemoListViewController: BaseViewController {

    
    // MARK: - LifeCycle
    let memoListView = MemoListView()
    override func loadView() {
        self.view = memoListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        setNavigation()
        setSearchController()
        setTableView()
    }
    
    
    func setNavigation() {
        navigationItem.title = "n개의 메모"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setNavigationBarButtonItem()
        setToolBarItem()
    }
    
    
    func setNavigationBarButtonItem() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(barButtonTapped))
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(barButtonTapped))
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    func setToolBarItem() {
        self.navigationController?.isToolbarHidden = false
        
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(barButtonTapped))
        rightBarButton.tintColor = .iconTint
        
        self.toolbarItems = [flexibleSpaceItem, rightBarButton]
    }
    
    
    func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
    }
    
    
    func setTableView() {
        memoListView.tableView.delegate = self
        memoListView.tableView.dataSource = self
        memoListView.tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.identifier)
        memoListView.tableView.register(MemoListTableViewHeader.self, forHeaderFooterViewReuseIdentifier: MemoListTableViewHeader.identifier)
    }
    
    
    @objc func barButtonTapped() {}
}




// MARK: - TableView Protocol
extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Section / Rows
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MemoListTableViewHeader.identifier) as? MemoListTableViewHeader else {
            return nil
        }
        
        header.headerTitle.text = section == 0 ? "고정된 메모" : "메모"
        
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = "TITLE"
        cell.dateLabel.text = "2022.02.04. 11:40"
        cell.contentLabel.text = "오늘은 달이 익어가니 서둘러 젊은 피야 민들레 한 송이 들고 사랑을 어더ㅉ고 저쩌고 그런이야기"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}




// MARK: - SearchController
extension MemoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "")
    }
}
