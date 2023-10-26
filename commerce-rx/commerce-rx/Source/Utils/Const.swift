
import Foundation

enum Const {
  static let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
  
  static let errorTag = 50
  static let loadingTag = 51
}

enum UserDefaultKeys: String {
  case accessToken
}

enum ViewStatus: String {
  case none, loading, error, finish
}
