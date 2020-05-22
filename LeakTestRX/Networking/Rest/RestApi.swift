import RxSwift
import RxCocoa
import Moya_ObjectMapper
import ObjectMapper
import Moya


enum ApiError: Error {
    case serverError(title: String, description: String)
}

class RestApi: API {
    func products() -> Observable<[ProductEntity]> {
        return requestMappedArray(.products, type: ProductEntity.self)
    }
    
    var provider : Networking
    
    init(provider: Networking) {
        self.provider = provider
    }
}

extension RestApi {
    
    private func requestMappedArray<T: BaseMappable>(_ target: ApiService, type: T.Type) -> Observable<[T]> {
        return provider.request(target)
            .mapArray(T.self, atKeyPath: "data")
            .observeOn(MainScheduler.instance)
    }
    
}
