//
//  MemoListViewModel.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/09/04.
//

import UIKit


enum TableViewType {
    case list
    case searchResult
}


struct MemoListViewModel {
    
    // MARK: - Propertys
    var repository = MemoDataRepository.shared
    
    var navigationTitle: String {
        return "\(repository.totalMemoCount)개의 메모"
    }
    
    var searchKeyword: String = "" {
        didSet {
            repository.fetchSearchResult(searchWord: searchKeyword)
        }
    }
    
    
    
    
    // MARK: - TableView Methods
    func numberOfSections(type: TableViewType) -> Int {
        return type == .list ? 2 : 1
    }
    
    
    func numberOfRowsInSection(type: TableViewType, section: Int) -> Int {
        switch type {
        case .list: return section == 0 ? repository.pinMemoCount : repository.memoCount
        case .searchResult: return repository.searchResultCount
        }
    }
    
    
    func viewForHeaderInSection(_ tableView: UITableView, type: TableViewType, section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MemoListTableViewHeader.identifier) as? MemoListTableViewHeader else {
            return nil
        }
    
        switch type {
        case .list:
            guard
                (repository.pinMemoCount > 0 && section == 0) ||
                (repository.memoCount > 0 && section == 1)
            else { return nil }
            
            header.headerTitle.text = section == 0 ? "고정된 메모" : "메모"
            
        case .searchResult:
            header.headerTitle.text = "\(repository.searchResultCount)개 찾음"
        }

        return header
    }
    
    
    func heightForHeaderInSection(section: Int) -> CGFloat {
        guard
            (repository.pinMemoCount > 0 && section == 0) ||
            (repository.memoCount > 0 && section == 1)
        else { return 0 }
        
        return 60
    }
    
    
    func cellForRowAt(_ tableView: UITableView, type: TableViewType, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
    
        if let data = getMemo(type: type, indexPath: indexPath) {
            cell.updateCell(data: data, keyword: searchKeyword)
        }
        
        return cell
    }
    
    
    func getMemo(type: TableViewType, indexPath: IndexPath) -> Memo? {
        switch type {
        case .list:
            return indexPath.section == 0 ? repository.getPinMemo(at: indexPath.row) : repository.getMemo(at: indexPath.row)
        case .searchResult:
            return repository.getSearchResult(at: indexPath.row)
        }
    }
    
    
    mutating func memoPinToggle(memo: Memo) -> Bool {
        repository.memoPinToggle(memo: memo)
    }
    
    
    func getSwipeAction(style: UIContextualAction.Style, image: UIImage?, color: UIColor?, handler: @escaping UIContextualAction.Handler) -> UIContextualAction {
        let action = UIContextualAction(style: style, title: nil, handler: handler)
        action.backgroundColor = color
        action.image = image
        
        return action
    }
    
    
    
    
    // MARK: - Database
    func removeMemo(memo: Memo) throws {
        try repository.remove(memo: memo)
    }
    
    
    func addObserver(completion: @escaping () -> Void) {
        repository.addObserver(completion: completion)
    }
}
