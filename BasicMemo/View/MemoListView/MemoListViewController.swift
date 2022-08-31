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
}
