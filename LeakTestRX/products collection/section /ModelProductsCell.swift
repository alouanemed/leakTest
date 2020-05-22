import UIKit
import RxCocoa
import RxSwift
import NVActivityIndicatorView

protocol ProductItemsDelegate: class {
    func didTapOnItem(p: ProductEntity)
}

class ModelProductsCell: CollectionViewTable {
 
    override func setup() {
        super.setup()
        
        collectionView.register(ProductItemCell.self, forCellWithReuseIdentifier: mainReuseIdentifier)
        
        stackView.snp.makeConstraints({ (make) in
            make.height.equalTo(215).priority(999)
        })
              
         collectionView.snp.makeConstraints({ (make) in
            make.height.equalToSuperview()
         })
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.itemSize = CGSize(width: 150, height: 215)
        }
    }
    
    let mainReuseIdentifier = "ProductViewCell"
    
    weak var delegate: ProductItemsDelegate?
    
    func bind(to viewModel: ModelProductsViewModel) {
        let input = ModelProductsViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.items
        .bind(to: collectionView.rx.items(cellIdentifier: mainReuseIdentifier, cellType: ProductItemCell.self)) { collectionView, viewModel, cell in
                cell.bind(to: viewModel)
        }.disposed(by: cellDisposeBag)
        
        collectionView.rx.modelSelected(ProductCellViewModel.self)
            .bind {[weak self] vm in
                self?.delegate?.didTapOnItem(p: vm.product)
        }.disposed(by: cellDisposeBag)
        
        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        
        isLoading.asDriver().drive(onNext: { [weak self] (isLoading) in
            isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }).disposed(by: cellDisposeBag)
    }
}
