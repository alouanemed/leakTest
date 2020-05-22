import RxSwift
import RxCocoa

class ProductCellViewModel {
    let title: Driver<String>
    let productId: Driver<String>

    var product: ProductEntity
    let onFavoriteTapped = PublishSubject<ProductEntity>()

    let isLoggedIn = Driver.just(false)

    init(with product: ProductEntity) {
        self.product = product
        productId = Driver.just("\(product.id ?? "")")
        
        title = Driver.just("\(product.name ?? "")")
         
    } 
}

extension ProductCellViewModel: Equatable {
    static func == (lhs: ProductCellViewModel, rhs: ProductCellViewModel) -> Bool {
        return lhs.product.id == rhs.product.id
    }
}
