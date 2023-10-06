
import Foundation
import Moya
import UIKit

enum HomeApi: ApiTargetType {
  case banners
  
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
    default: return .requestPlain
    }
  }
  
  var sampleData: Data {
    switch self {
    case .banners:
      return NSDataAsset(name: "")!.data
    }
  }
}
