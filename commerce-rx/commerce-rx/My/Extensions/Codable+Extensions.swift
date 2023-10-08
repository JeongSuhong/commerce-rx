
import Foundation

extension Encodable {
  func asDic() -> [String : Any]? {
    if let data = try? JSONEncoder().encode(self),
       let dic = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String : Any] {
      return dic
    }
    
    return nil
  }
}
