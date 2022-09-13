//
//  MemoListViewController.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import UIKit

final class MemoListViewController: BaseViewController {

    // MARK: - Propertys
    private var viewModel = MemoListViewModel()
    
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
        navigationItem.title = viewModel.navigationTitle
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
        viewModel.addObserver { [weak self] in
            guard let self = self else { return }
            self.memoListView.tableView.reloadData()
            self.resultTableViewController.tableView.reloadData()
            self.navigationItem.title = self.viewModel.navigationTitle
        }
    }
    
    
    private func presentPopUp() {
        if UserDefaultManager.shared.isInitialLaunch {
            let popUpVC = PopUpViewController()
            popUpVC.view.backgroundColor = .black.withAlphaComponent(0.5)
            transition(popUpVC, transitionStyle: .presentOverFullScreen)
        }
    }
    
    
    @objc private func writeButtonTapped() {
        let vc = WriteMemoViewController()
        vc.currentViewStatus = .write
        transition(vc, transitionStyle: .push)
    }
}




// MARK: - TableView Protocol
extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Section / Rows
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == memoListView.tableView {
            return viewModel.numberOfSections(type: .list)
        }else {
            return viewModel.numberOfSections(type: .searchResult)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == memoListView.tableView {
            return viewModel.numberOfRowsInSection(type: .list, section: section)
        }else {
            return viewModel.numberOfRowsInSection(type: .searchResult, section: section)
        }
    }
    
    
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == memoListView.tableView {
            return viewModel.viewForHeaderInSection(tableView, type: .list, section: section)
        }else {
            return viewModel.viewForHeaderInSection(tableView, type: .searchResult, section: section)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == memoListView.tableView {
            return viewModel.heightForHeaderInSection(section: section)
        }else {
            return viewModel.heightForHeaderInSection(section: section)
        }
    }
    
    
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == memoListView.tableView {
            return viewModel.cellForRowAt(tableView, type: .list, indexPath: indexPath)
        }else {
            return viewModel.cellForRowAt(tableView, type: .searchResult, indexPath: indexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    // Leading Swipe
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dataToUpdate: Memo?
        
        if tableView == memoListView.tableView {
            dataToUpdate = viewModel.getMemo(type: .list, indexPath: indexPath)
        }else {
            dataToUpdate = viewModel.getMemo(type: .searchResult, indexPath: indexPath)
        }
        
        let image = dataToUpdate?.isSetPin ?? false ? UIImage(systemName: "pin.slash.fill") : UIImage(systemName: "pin.fill")

        let pin = viewModel.getSwipeAction(style: .normal, image: image, color: .systemOrange) { [weak self] action, view, completion in
            guard let self = self else { return }
            if !self.viewModel.memoPinToggle(memo: dataToUpdate!) {
                self.showAlert(title: "메모는 최대 5개까지 고정시킬 수 있습니다.")
            }
        }
        
        return UISwipeActionsConfiguration(actions: [pin])
    }
    
    
    // Trailing Swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dataToDelete: Memo?
        
        if tableView == memoListView.tableView {
            dataToDelete = viewModel.getMemo(type: .list, indexPath: indexPath)
        }else {
            dataToDelete = viewModel.getMemo(type: .searchResult, indexPath: indexPath)
        }
        
        let image = UIImage(systemName: "trash.fill")
        
        let delete = viewModel.getSwipeAction(style: .destructive, image: image, color: nil) { [weak self] action, view, completion in
            guard let self = self else { return }
            self.showAlert(title: "정말 삭제하시겠어요??", buttonTitle: "삭제", cancelTitle: "취소") { _ in
                do {
                    if let dataToDelete = dataToDelete {
                        try self.viewModel.removeMemo(memo: dataToDelete)
                    }
                }
                catch {
                    self.showErrorAlert(error: error)
                }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    
    // Select Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WriteMemoViewController()
        var selectedMemo: Memo?

        if tableView == memoListView.tableView {
            selectedMemo = viewModel.getMemo(type: .list, indexPath: indexPath)
        }else {
            selectedMemo = viewModel.getMemo(type: .searchResult, indexPath: indexPath)
            vc.backButtonTitle = .검색
        }
        
        vc.readMemo = selectedMemo
        vc.currentViewStatus = .read
        transition(vc, transitionStyle: .push)
    }
}




// MARK: - SearchController
extension MemoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchKeyword = searchController.searchBar.text ?? ""
        resultTableViewController.tableView.reloadData()
    }
}
