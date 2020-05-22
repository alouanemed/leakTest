import RxSwift
import Moya
import Alamofire
import ObjectMapper

protocol AuthorizedTargetType {
    var needsAuth: Bool { get }
}

enum ApiService {
    // MARK: - Account
    case products
     
}

extension ApiService: TargetType, AuthorizedTargetType {

    var baseURL: URL {
        return URL(string: "http://dummy.restapiexample.com")!
    }
    
    var path: String {
        switch self {
        case .products: return "/api/v1/employees"
         
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var headers: [String: String]? {
        //return ["Authorization": "\(basicToken)"]
        return nil
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        return params
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        
        return Data()
    }
    
    public var task: Task {
       guard let parameters = self.parameters else {
                       return .requestPlain
                   }
                   return .requestParameters(parameters: parameters, encoding: parameterEncoding)
    }
    
    var needsAuth: Bool {
        switch self {
        default: return true
        }
    }
}
