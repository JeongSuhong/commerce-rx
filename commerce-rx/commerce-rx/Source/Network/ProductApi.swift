
import Foundation
import Moya
import UIKit

enum ProductApi: ApiTargetType {
case list(ProductListReq)
  case like(String)
  case dislike(String)
  case detail(String)
  
  var path: String {
    switch self {
    default:
      return ""
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .like:
      return .post
    case .dislike:
      return .delete
    default:
return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .list(let params):
      return .requestParameters(parameters: params.asDic() ?? [:], encoding: URLEncoding.default)
    default:
      return .requestPlain
    }
  }
  
  var sampleData: Data {
    switch self {
    case .list(let req):
      switch req.type {
      case .related:
        return NSDataAsset(name: "product-related")!.data
      default:
        return NSDataAsset(name: "product-list")!.data
      }
      
    case .detail:
      return NSDataAsset(name: "product-detail")!.data
      
    default:
      return Data()
      }
  }
}

struct ProductListReq: Codable {
  let start: Int
  let perPage: Int
  var type: productType?
  var search: String?
  var categoryId: Int?
  
  
  enum productType: String, Codable {
    case related, liked
  }
}

struct ProductListRes: Codable {
  let data: [productRes]
  let total: Int
  
  struct productRes: Codable {
    let id: String
    let type: ProductType?
    let name: String
    let price: Int
    let originPrice: Int
    let createdAt: String
    let brandName: String
    let brandId: String
    let representativeImage: String
    let benefit: productBenefitRes?
    let category: [productCategoryRes]
    let isLike: Bool
  }
}

struct productBenefitRes: Codable {
  let type: ProductBenefitType
  let amount: Int
}

struct productCategoryRes: Codable {
  let id: Int
  let name: String
}

struct ProductDetailRes: Codable {
  let id: String
  let type: ProductType?
  let name: String
  let price: Int
  let originPrice: Int
  let createdAt: String
  let brandName: String
  let brandId: String
  let brandImage: String
  let representativeImage: String
  let images: [ProductImageRes]
  let benefit: productBenefitRes?
  let category: [productCategoryRes]
  let isLike: Bool
  let detailContent: String
  let reviewRating: Double
  let reviewCount: Int
  let detailImages: [ProductImageRes]
}

struct ProductImageRes: Codable {
  let id: String
  let url: String
  let width: Int?
  let height: Int?
}



