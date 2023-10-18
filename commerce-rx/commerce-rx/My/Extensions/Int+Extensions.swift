
import Foundation

extension Int {
  func toPercent(_ value: Int) -> Int {
    if self == .zero || value == .zero  { return 0 }
    return Int((Double(value - self) / Double(value) * 100.0).rounded())
  }
}
