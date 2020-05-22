//
//  TableViewController.swift
//  RxTheme_Example
//
//  Created by Mohamed Alouane on 5/21/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView
import KafkaRefresh


class TableViewController: ViewController, UIScrollViewDelegate {
    
    var retryRefreshTrigger = PublishSubject<Void>()
    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()

    let isHeaderLoading = BehaviorRelay(value: false)
    let isFooterLoading = BehaviorRelay(value: false)
    
    lazy var tableView: TableView = {
        let view = TableView(frame: CGRect(), style: .plain)
        view.rx.setDelegate(self).disposed(by: rx.disposeBag)
        return view
    }()
     
    var clearsSelectionOnViewWillAppear = true
    
    override func makeUI() {
        super.makeUI()

        stackView.spacing = 0
        stackView.addArrangedSubview(tableView)
        
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = .init(top: 5, left: 0, bottom: 0, right: 0)
        
        tableView.bindGlobalStyle(forHeadRefreshHandler: { [weak self] in
             self?.headerRefreshTrigger.onNext(())
        })

        tableView.bindGlobalStyle(forFootRefreshHandler: { [weak self] in
            self?.footerRefreshTrigger.onNext(())
        })

        isHeaderLoading.bind(to: tableView.headRefreshControl.rx.isAnimating).disposed(by: rx.disposeBag)
        
        isFooterLoading.bind(to: tableView.footRefreshControl.rx.isAnimating).disposed(by: rx.disposeBag)

        tableView.footRefreshControl.autoRefreshOnFoot = true
    }
    
    func setupViews(){
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        self.view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.view)
            make.height.equalTo(50)
        }
    }
     
    override func updateUI() {
        super.updateUI()
    }
    
}

extension TableViewController {
    func deselectSelectedRow() {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            selectedIndexPaths.forEach({ (indexPath) in
                tableView.deselectRow(at: indexPath, animated: false)
            })
        }
    }
}
 

import UIKit

class TableView: UITableView {

    init () {
        super.init(frame: CGRect(), style: .grouped)
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 50
        sectionHeaderHeight = 40
        backgroundColor = .clear
        cellLayoutMarginsFollowReadableWidth = false
        keyboardDismissMode = .onDrag
        tableHeaderView = UIView()
        tableFooterView = UIView()
        backgroundColor = .clear
    }
}
