import RxSwift
import Moya

protocol API {
       func products() -> Observable<[ProductEntity]>
}

