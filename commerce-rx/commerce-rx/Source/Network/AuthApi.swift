
import Foundation
import Moya
import UIKit

enum AuthApi: ApiTargetType {
  case refreshToken(_ params: RefreshTokenReq)
  
  var path: String {
    switch self {
    default:
      return ""
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .refreshToken:
      return .post
    default:
return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .refreshToken(let params):
      return .requestJSONEncodable(params)
    default:
      return .requestPlain
    }
  }
  
  var sampleData: Data {
    switch self {
    default:
        return NSDataAsset(name: "")!.data
      }
  }
}

struct RefreshTokenReq: Codable {
  let refreshToken: String
}

struct RefreshTokenRes: Codable {
  let accessToken: String
  let refreshToken: String
  let userId: String
}

