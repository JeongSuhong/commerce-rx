
import Foundation
import Moya
import UIKit

enum ___VARIABLE_productName___Api: ApiTargetType {

  var path: String {
    switch self {
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
  
  var task: Moya.Task {
    switch self {
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


