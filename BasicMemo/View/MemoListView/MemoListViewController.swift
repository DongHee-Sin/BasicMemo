//
//  MemoListViewController.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import UIKit

final class MemoListViewController: BaseViewController {

    // MARK: - Propertys
    var memoManager = MemoDataManager()
    
    
    
    
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
        setRealmObserver()
    }
    
    
    func setNavigation() {
        navigationItem.title = "\(1234.addComma ?? "")개의 메모"
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
    
    
    func setRealmObserver() {
        memoManager.addObserver { [weak self] in
            self?.memoManager.fetchData()
            self?.memoListView.tableView.reloadSections([0], with: .fade)
        }
    }
    
    
    @objc func barButtonTapped() {
        do {
            try memoManager.write(Memo(title: "TITLE", content: "CONTENT"))
        }
        catch {
            print(error)
        }
    }
}




// MARK: - TableView Protocol
extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Section / Rows
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? memoManager.pinMemoCount : memoManager.memoCount
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
        
        let data = indexPath.section == 0 ? memoManager.getPinMemo(at: indexPath.row) : memoManager.getMemo(at: indexPath.row)
        if let data = data {
            cell.updateCell(data: data)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    // Leading Swipe
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pin = UIContextualAction(style: .normal, title: nil, handler: { [weak self] action, view, completion in
            guard let self = self else { return }
            if !self.memoManager.memoPinToggle(at: indexPath.row, section: indexPath.section) {
                self.showAlert(title: "메모는 최대 5개까지 고정시킬 수 있습니다.")
            }
        })
        pin.backgroundColor = .systemOrange
        pin.image = UIImage(systemName: "pin.fill")
        
        return UISwipeActionsConfiguration(actions: [pin])
    }
    
    
    // Trailing Swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.showAlert(title: "정말 삭제하시겠어요??", buttonTitle: "삭제", cancelTitle: "취소") { _ in
                do {
                    try self.memoManager.remove(at: indexPath.row, section: indexPath.section)
                }
                catch {
                    self.showAlert(title: "데이터 삭제에 실패했습니다.")
                }
            }
        }
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}




// MARK: - SearchController
extension MemoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "")
    }
}
