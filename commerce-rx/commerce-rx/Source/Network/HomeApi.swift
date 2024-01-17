
import Foundation
import Moya
import UIKit

enum HomeApi: ApiTargetType {
  case banners
  case categorys(HomeCategorysReq)
  
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
    case let .categorys(params):
      return .requestParameters(parameters: params.asDic() ?? [:], encoding: URLEncoding.default)
    default: return .requestPlain
    }
  }
  
  var sampleData: Data {
    switch self {
    case .banners:
      return NSDataAsset(name: "home-banner")!.data
    
    case let .categorys(req):
      switch req.type {
      case .home:
        return NSDataAsset(name: "home-categorys-home")!.data
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
