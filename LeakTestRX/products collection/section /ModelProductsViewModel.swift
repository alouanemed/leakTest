import RxCocoa
import RxSwift

class ModelProductsViewModel: ViewModel, ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        let items: Observable<[ProductCellViewModel]>
    } 
    let elements = BehaviorRelay<[ProductCellViewModel]>(value: [])
    
    
    let onFavorited = PublishSubject<Bool>()
    let onFavoriteTapped = PublishSubject<ProductEntity?>()
    
    func transform(input: Input) -> Output {
        
        //Header
        Observable.just(!elements.value.isEmpty).filter{$0 == false}.flatMapLatest({[weak self] (_) -> Observable<[ProductCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            
            self.page = 1
            
            return self.request()
                .trackActivity(self.loading)
                .trackError(self.error)
                .catchError { _ in Observable.empty() }
            
        }).bind(to: elements).disposed(by: rx.disposeBag)
        
        onFavoriteTapped.subscribe(onNext: { [weak self] (product) in
            guard let self = self else { return }
            
            let id = product?.id ?? ""
            
            if !Bool.random(){
                self.favoriteProduct(id: id)
            }else{
                self.unfavoriteProduct(id: id)
            }
        }).disposed(by: rx.disposeBag)
        
        return Output(items: elements.asObservable())
    }
    
    
    func request() -> Observable<[ProductCellViewModel]> {
        var request: Observable<[ProductEntity]>
        request = self.provider.products().scan(into: [ProductEntity]()) { current, next in
            current = next
        }
        
        return request.map {[weak self] (list) -> [ProductCellViewModel] in
            guard let self = self else { return [] }
            
            return list.map {
                let vm = ProductCellViewModel(with: $0)
                vm.onFavoriteTapped.bind(to: self.onFavoriteTapped).disposed(by: self.rx.disposeBag)
                return vm
            }
        }
    }
    
    func favoriteProduct(id: String){
        self.onFavorited.onNext(true)
    }
    
    func unfavoriteProduct(id: String){
        self.onFavorited.onNext(false)
    }
    
}
