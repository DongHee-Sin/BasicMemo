//
//  MemoListViewController.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import UIKit

final class MemoListViewController: BaseViewController {

    // MARK: - Propertys
    private var memoManager = MemoDataManager()
    
    private let resultTableViewController = SearchResultTableViewController(style: .insetGrouped)
    
    private var searchKeyword: String = ""
    
    
    
    
    // MARK: - LifeCycle
    private let memoListView = MemoListView()
    override func loadView() {
        self.view = memoListView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentPopUp()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        setSearchController()
        setTableView()
        setRealmObserver()
    }
    
    
    override func setNavigationBar() {
        navigationItem.title = "\(memoManager.totalMemoCount)개의 메모"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setNavigationBarButtonItem()
        setToolBarItem()
    }
    
    
    private func setNavigationBarButtonItem() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(barButtonTapped))
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(barButtonTapped))
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    private func setToolBarItem() {
        self.navigationController?.isToolbarHidden = false
        
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let writeMemoBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonTapped))
        writeMemoBarButton.tintColor = .iconTint
        
        self.toolbarItems = [flexibleSpaceItem, writeMemoBarButton]
    }
    
    
    private func setSearchController() {
        let searchController = UISearchController(searchResultsController: resultTableViewController)
        searchController.searchBar.placeholder = "검색"
        
        resultTableViewController.tableView.delegate = self
        resultTableViewController.tableView.dataSource = self
        resultTableViewController.tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.identifier)
        resultTableViewController.tableView.register(MemoListTableViewHeader.self, forHeaderFooterViewReuseIdentifier: MemoListTableViewHeader.identifier)
        resultTableViewController.tableView.keyboardDismissMode = .onDrag
        
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
    }
    
    
    private func setTableView() {
        memoListView.tableView.delegate = self
        memoListView.tableView.dataSource = self
        memoListView.tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.identifier)
        memoListView.tableView.register(MemoListTableViewHeader.self, forHeaderFooterViewReuseIdentifier: MemoListTableViewHeader.identifier)
    }
    
    
    private func setRealmObserver() {
        memoManager.addObserver { [weak self] in
            guard let self = self else { return }
            self.memoListView.tableView.reloadData()
            self.resultTableViewController.tableView.reloadData()
            self.navigationItem.title = "\(self.memoManager.totalMemoCount)개의 메모"
        }
    }
    
    
    private func presentPopUp() {
        if !UserDefaults.standard.bool(forKey: "PopUp") {
            let popUpVC = PopUpViewController()
            popUpVC.view.backgroundColor = .black.withAlphaComponent(0.5)
            transition(popUpVC, transitionStyle: .presentOverFullScreen)
        }
    }
    
    
    @objc private func barButtonTapped() { }
    
    
    @objc private func writeButtonTapped() {
        let vc = WriteMemoViewController()
        vc.currentViewStatus = .write
        vc.delegate = self
        transition(vc, transitionStyle: .push)
    }
}




// MARK: - TableView Protocol
extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Section / Rows
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == memoListView.tableView {
            return 2
        }else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == memoListView.tableView {
            return section == 0 ? memoManager.pinMemoCount : memoManager.memoCount
        }else {
            return memoManager.searchResultCount
        }
    }
    
    
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MemoListTableViewHeader.identifier) as? MemoListTableViewHeader else {
            return nil
        }
        
        if tableView == memoListView.tableView {
            guard memoManager.pinMemoCount > 0 || section != 0 else { return nil }
            guard memoManager.memoCount > 0 || section != 1 else { return nil }
            header.headerTitle.text = section == 0 ? "고정된 메모" : "메모"
        }else {
            header.headerTitle.text = "\(memoManager.searchResultCount)개 찾음"
        }

        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard memoManager.pinMemoCount > 0 || section != 0 else { return 0 }
        
        return 60
    }
    
    
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        
        if tableView == memoListView.tableView {
            let data = indexPath.section == 0 ? memoManager.getPinMemo(at: indexPath.row) : memoManager.getMemo(at: indexPath.row)
            if let data = data {
                cell.updateCell(data: data)
            }
        }else {
            let data = memoManager.getSearchResult(at: indexPath.row)
            if let data = data {
                cell.updateCell(data: data, keyword: searchKeyword)
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    // Leading Swipe
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dataToUpdate: Memo?
        
        if tableView == memoListView.tableView {
            dataToUpdate = indexPath.section == 0 ? memoManager.getPinMemo(at: indexPath.row) : memoManager.getMemo(at: indexPath.row)
        }else {
            dataToUpdate = memoManager.getSearchResult(at: indexPath.row)
        }
        
        let pin = UIContextualAction(style: .normal, title: nil, handler: { [weak self] action, view, completion in
            guard let self = self else { return }
            if !self.memoManager.memoPinToggle(memo: dataToUpdate ?? Memo()) {
                self.showAlert(title: "메모는 최대 5개까지 고정시킬 수 있습니다.")
            }
        })
        pin.backgroundColor = .systemOrange
        pin.image = UIImage(systemName: "pin.fill")
        
        return UISwipeActionsConfiguration(actions: [pin])
    }
    
    
    // Trailing Swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dataToDelete: Memo?
        
        if tableView == memoListView.tableView {
            dataToDelete = indexPath.section == 0 ? memoManager.getPinMemo(at: indexPath.row) : memoManager.getMemo(at: indexPath.row)
        }else {
            dataToDelete = memoManager.getSearchResult(at: indexPath.row)
        }
        
        let delete = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.showAlert(title: "정말 삭제하시겠어요??", buttonTitle: "삭제", cancelTitle: "취소") { _ in
                do {
                    try self.memoManager.remove(memo: dataToDelete ?? Memo())
                }
                catch {
                    self.showAlert(title: "데이터 삭제에 실패했습니다.")
                }
            }
        }
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    
    // Select Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedMemo: Memo?

        if tableView == memoListView.tableView {
            selectedMemo = indexPath.section == 0 ? memoManager.getPinMemo(at: indexPath.row) : memoManager.getMemo(at: indexPath.row)
        }else {
            selectedMemo = memoManager.getSearchResult(at: indexPath.row)
        }
        
        let vc = WriteMemoViewController()
        vc.readMemo = selectedMemo
        vc.delegate = self
        vc.currentViewStatus = .read
        transition(vc, transitionStyle: .push)
    }
}




// MARK: - SearchController
extension MemoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchKeyword = searchController.searchBar.text ?? ""
        memoManager.fetchSearchResult(searchWord: searchKeyword)
        resultTableViewController.tableView.reloadData()
    }
}




// MARK: - Save Memo Delegate
extension MemoListViewController: ManagingMemoDelegate {
    
    func saveMemo(title: String, content: String) {
        let memo = Memo(title: title, content: content)
        
        do {
            try memoManager.create(memo)
        }
        catch {
            showAlert(title: "메모 저장에 실패했습니다.")
        }
    }
    
    
    func updateMemo(memo: Memo, title: String, content: String) {
        do {
            try memoManager.update(memo: memo) { memo in
                memo.title = title
                memo.content = content
                memo.savedDate = Date()
            }
        }
        catch {
            showAlert(title: "메모 저장에 실패했습니다.")
        }
    }
    
    
    func removeMemo(memo: Memo) {
        do {
            try memoManager.remove(memo: memo)
            
        }
        catch {
            showAlert(title: "메모 삭제에 실패했습니다.")
        }
    }
}
