//
//  sdf.swift
//  LeakTestRX
//
//  Created by Mohamed Alouane on 5/22/20.
//  Copyright © 2020 malouane. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import NVActivityIndicatorView
import DZNEmptyDataSet

class CollectionViewTable: UITableViewCell {
    var cellDisposeBag = DisposeBag()
    
  var emptyDataSetTitle = "commonNoResults"

    let activityIndicator = NVActivityIndicatorView(frame: CGRect())
    let isLoading = BehaviorRelay(value: false)

    lazy var collectionView: CollectionView = {
        let view = CollectionView()
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let subviews: [UIView] = []
        let view = UIStackView(arrangedSubviews: subviews)
        view.axis = .horizontal
        view.alignment = .center
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(10)
        })
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    func makeUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        updateUI()
        setup()
    }
     
    func setup() {
        
        stackView.spacing = 0
        
        stackView.addArrangedSubview(collectionView)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.itemSize = CGSize(width: 150, height: 200)
        }
        
        collectionView.showsHorizontalScrollIndicator = false
        
        stackView.addArrangedSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints({ (make) in
            make.height.equalTo(50)
            make.centerY.centerX.equalTo(self.stackView)
        })
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        cellDisposeBag = DisposeBag()
    }
}

 extension CollectionViewTable: DZNEmptyDataSetDelegate {
     
//     func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//         return R.image.icon_toast_warning()
//     }
//
     func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
         return .red
     }
     func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
         return true
     }
     
     func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
         return false
     }
     
     func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
         return true
     }
 }

 extension CollectionViewTable: DZNEmptyDataSetSource {
     
 
     func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
         return .clear
     }
     
     func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
         return -10
     }
 }


class CollectionView: UICollectionView {

    init() {
        super.init(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        makeUI()
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        self.layer.masksToBounds = true
        self.backgroundColor = .clear
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }

    func itemWidth(forItemsPerRow itemsPerRow: Int, withInset inset: CGFloat = 0) -> CGFloat {
        let collectionWidth = Int(frame.size.width)
        if collectionWidth == 0 {
            return 0
        }
        return CGFloat(Int((collectionWidth - (itemsPerRow + 1) * Int(inset)) / itemsPerRow))
    }

    func setItemSize(_ size: CGSize) {
        if size.width == 0 || size.height == 0 {
            return
        }
        let layout = (self.collectionViewLayout as? UICollectionViewFlowLayout)!
        layout.itemSize = size
    }
}
