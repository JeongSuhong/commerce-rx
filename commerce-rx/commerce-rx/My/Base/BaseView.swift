

import Foundation
import UIKit

class BaseView: UIView {
  
  @IBInspectable
  var autoCorner: Bool {
    get { _ibAutoCorner }
    set { _ibAutoCorner = newValue }
  }
  
  private var _ibAutoCorner: Bool = false {
    didSet {
      self.layer.cornerRadius = self.frame.height / 2.0
      self.clipsToBounds = self.layer.cornerRadius > 0
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    update()
  }
  
  private func update() {
    _ibAutoCorner = autoCorner
  }
}
