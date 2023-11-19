
import Foundation

enum Const {
  static let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
  
  static let errorTag = 50
  static let loadingTag = 51
}

enum UserDefaultKeys: String {
  case accessToken, refreshToken
}

enum ViewStatus: String {
  case none, loading, loadingScroll, error, finish
}
