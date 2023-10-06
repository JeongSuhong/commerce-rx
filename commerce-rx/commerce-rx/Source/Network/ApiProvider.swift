

import Foundation
import Moya

class ApiProvider {
  static let shared = MoyaProvider<MultiTarget>()
  
  
}

protocol ApiTargetType: TargetType { }
extension ApiTargetType {
  var baseURL: URL { URL(string: "")! }
  
  var headers: [String: String]? {
    return ["Content-type": "application/json"]
  }
}
