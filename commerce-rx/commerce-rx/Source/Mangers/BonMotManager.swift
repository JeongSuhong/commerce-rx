

import Foundation
import UIKit
import BonMot
import SnapKit

class BonMotManagr {
  static func setupStyles() {
    let fontSize: [CGFloat] = [8, 10, 12, 14, 16, 18, 20, 24]
    fontSize.forEach { size in
      let boldStyle = StringStyle(.font(.nanumGothicBold(size: size)))
      NamedStyles.shared.registerStyle(forName: "nanumB_\(Int(size))", style: boldStyle)
      
      let style = StringStyle(.font(.nanumGothic(size: size)))
      NamedStyles.shared.registerStyle(forName: "nanum_\(Int(size))", style: style)
      
      let lightStyle = StringStyle(.font(.nanumGothicLight(size: size)))
      NamedStyles.shared.registerStyle(forName: "nanumL_\(Int(size))", style: lightStyle)
      
      let ultraLightStyle = StringStyle(.font(.nanumGothicUltraLight(size: size)))
      NamedStyles.shared.registerStyle(forName: "nanumUL_\(Int(size))", style: lightStyle)
    }
  }
}
