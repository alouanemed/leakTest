import UIKit
import SnapKit

class ProductItemCell: CollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup() 
    }
    
    func bind(to viewModel: ProductCellViewModel) {
        viewModel.isLoggedIn.drive(onNext: { [weak self] (isLoggedIn) in
            guard let self = self else { return }
 
            
        }).disposed(by: cellDisposeBag)

        viewModel.title.drive(productNameLabel.rx.text).disposed(by: cellDisposeBag)
        
//        viewModel.labelURLs.drive(onNext: { [weak self] (labels) in
//            guard let self = self else { return }
//
//            self.labelsStack.removeAllRows()
//
//            var count = 0
//            for url in labels {
//                if count < 2 {
//                    let iv = self.styleImageView(view: ImageView())
//                    iv.kf.setImage(with: url)
//                    self.labelsStack.addRow(iv)
//                    self.labelsStack.setInset(forRow: iv, inset: .init(top: 0, left: 0, bottom: 0, right: 5))
//                    iv.snp.makeConstraints { (make) -> Void in
//                        make.height.equalTo(30)
//                        make.width.equalTo(30)
//                    }
//                }else{
//                    self.moreLabel.text = "+\(labels.count - 2)"
//                    self.labelsStack.addRow(self.moreLabel)
//                    self.labelsStack.setInset(forRow: self.moreLabel, inset: .init(top: 0, left: 0, bottom: 0, right: 5))
//                    self.moreLabel.snp.makeConstraints { (make) -> Void in
//                        make.height.width.equalTo(Configs.BaseDimensions.size30)
//                          }
//
//                    return
//                }
//                count += 1
//            }
//        }).disposed(by: cellDisposeBag)
        
//        viewModel.isFavorite.drive(onNext: { [weak self] (isFavorite) in
//            if isFavorite {
//                self?.favoriteIv.image = R.image.icon_favorite_check()
//            }else{
//                self?.favoriteIv.image = R.image.icon_favorite_uncheck()
//            }
//        }).disposed(by: cellDisposeBag)
//
//      let product = viewModel.product
//        favoriteIv.rx.tap().map { _ in
//            product
//        }
//        .bind(to: viewModel.onFavoriteTapped)
//        .disposed(by: cellDisposeBag)
    }
    
    func setup() {
        themeService.rx
            .bind({ $0.text }, to: productNameLabel.rx.textColor)
            .bind({ $0.backgroundColor }, to: contentView.rx.backgroundColor)
            .disposed(by: cellDisposeBag)
           
        self.addSubview(productNameLabel) 
         
        
        productNameLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
      
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
