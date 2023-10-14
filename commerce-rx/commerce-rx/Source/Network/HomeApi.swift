
import Foundation
import Moya
import UIKit

enum HomeApi: ApiTargetType {
  case banners
  case categorys(HomeCategorysReq)
  case products(HomeProductsReq)
  
  var path: String {
    switch self {
    default: return ""
    }
  }
  
  var method: Moya.Method {
    switch self {
    default: return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .categorys(let params):
      return .requestParameters(parameters: params.asDic() ?? [:], encoding: URLEncoding.default)
    case .products(let params):
      return .requestParameters(parameters: params.asDic() ?? [:], encoding: URLEncoding.default)
    default: return .requestPlain
    }
  }
  
  var sampleData: Data {
    switch self {
    case .banners:
      return NSDataAsset(name: "home-banner")!.data
    
    case .categorys(let req):
      switch req.type {
      case .home:
        return NSDataAsset(name: "home-categorys-home")!.data
      }
    
    case .products(let req):
      switch req.type {
      case .related:
        return NSDataAsset(name: "home-products-related")!.data
        
      default:
        return Data()
      }
    }
  }
}


struct BannersRes: Codable {
  var data: [BannerRes]
  
  struct BannerRes: Codable {
    let name: String
    let id: String
    let type: bannerType
    let titleImage: String
    let value: String
  }
  
  enum bannerType: String, Codable {
    case url, products, categories, events
  }
}

struct HomeCategorysReq: Codable {
  var type: categoryType
  
  enum categoryType: String, Codable {
    case home
  }
}

struct HomeCategorysRes: Codable {
  let data: [categoryRes]
  
  struct categoryRes: Codable {
    let name: String
    let id: String
    let type: categoryType
    let titleImage: String
    let value: String?
  }
  
  enum categoryType: String, Codable {
    case delivery, list
  }
}

struct HomeProductsReq: Codable {
  let start: Int
  let perPage: Int
  var type: productType?
  var search: String?
  var categoryId: Int?
  
  
  enum productType: String, Codable {
    case related, liked
  }
}

struct HomeProductListRes: Codable {
  let data: [productRes]
  let total: Int
  
  struct productRes: Codable {
    let id: String
    let type: productType?
    let name: String
    let price: Int
    let originPrice: Int
    let createdAt: String
    let brandName: String
    let brandId: String
    let representativeImage: String
    let benefit: productBenefitRes?
    let category: [productCategoryRes]
  }
  
  enum productType: String, Codable {
    case myDelivery, todayDelivery
  }
  
  struct productBenefitRes: Codable {
    let type: benefitType
    let amount: Int
  }
  
  enum benefitType: String, Codable {
    case coupon, creditcard
  }
  
  struct productCategoryRes: Codable {
    let id: Int
    let name: String
  }
}
