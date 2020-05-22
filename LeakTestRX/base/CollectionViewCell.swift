//
//  asd.swift
//  LeakTestRX
//
//  Created by Mohamed Alouane on 5/22/20.
//  Copyright © 2020 malouane. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import RxSwift
import RxCocoa


class CollectionViewCell: UICollectionViewCell, NVActivityIndicatorViewable {
    
    // MARK: - RX helpers
    var cellDisposeBag = DisposeBag()
    
    // MARK: - Loading
    let activityIndicator = NVActivityIndicatorView(frame: CGRect())
    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()
    
    let isHeaderLoading = BehaviorRelay(value: false)
    let isFooterLoading = BehaviorRelay(value: false)
    let isLoading = BehaviorRelay(value: false)
       
    func makeUI() {
        self.layer.masksToBounds = true
        updateUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
    
    func setupViews() {
        let xAxis = self.center.x
        let yAxis = self.center.y
        
        let frame = CGRect(x: xAxis - 30, y: yAxis - 20, width: 45, height: 45)
        activityIndicator.frame = frame
        themeService.rx
            .bind({ $0.backgroundColor }, to: rx.backgroundColor)
            .disposed(by: rx.disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var stackView: UIStackView = {
        let subviews: [UIView] = []
        let view = UIStackView(arrangedSubviews: subviews)
        view.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.alignment = .center
        return view
    }()
    
    override func prepareForReuse(){
        super.prepareForReuse()
        cellDisposeBag = DisposeBag()
    }
    
}


extension Reactive where Base: CollectionViewCell {
    
    var backgroundColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.backgroundColor = attr
        }
    }
}
