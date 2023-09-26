

import Foundation
import UIKit
import BonMot
import SnapKit

class BonMotManagr {
  static func setupStyles() {
    NamedStyles.shared.registerStyle(forName: "tabSelect", style: tabSelect)
    NamedStyles.shared.registerStyle(forName: "tab", style: tab)
    NamedStyles.shared.registerStyle(forName: "content", style: contentStyle)
  }
}

extension BonMotManagr {
  static let tabSelect = StringStyle(
    .font(UIFont(name: "NanumBarunGothicBold", size: 12)!)
  )
  
  static let tab = StringStyle(
    .font(UIFont(name: "NanumBarunGothic", size: 12)!)
  )

  static let contentStyle = StringStyle(
    .font(UIFont(name: "NanumBarunGothic", size: 14)!)
  )
}
