import Foundation

extension NSObject {
  static var className: String {
    return String(describing: self).components(separatedBy: ".").last ?? ""
  }
}
