

import Foundation
import UIKit
import BonMot
import SnapKit

class BonMotManagr {
  static func setupStyles() {
    let fontSize: [CGFloat] = [8, 10, 12, 16, 20, 24]
    fontSize.forEach { size in
      let boldStyle = StringStyle(.font(UIFont(name: "NanumBarunGothicBold", size: size)!))
      NamedStyles.shared.registerStyle(forName: "nanumB_\(Int(size))", style: boldStyle)
      
      let style = StringStyle(.font(UIFont(name: "NanumBarunGothic", size: size)!))
      NamedStyles.shared.registerStyle(forName: "nanum_\(Int(size))", style: style)
      
      let lightStyle = StringStyle(.font(UIFont(name: "NanumBarunGothic", size: size)!))
      NamedStyles.shared.registerStyle(forName: "nanumL_\(Int(size))", style: lightStyle)
    }
  }
}
