import Foundation
import ObjectMapper


class ProductEntity : Mappable{
     
    var id : String?
    var name : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ProductEntity()
    }
    required init?(map: Map){}
    private init(){}
    
    func mapping(map: Map)
    {
        id <- map["id"]
        name <- map["employee_name"]
        
    }
     
}
