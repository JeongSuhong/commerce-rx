

import Foundation
import UIKit
import FSPagerView

class BasePagerViewCell: FSPagerViewCell {
  override var isSelected: Bool {
    set { super.isSelected = false }
    get { super.isSelected }
  }
  
  override var isHighlighted: Bool {
    set { super.isHighlighted = false }
    get { super.isHighlighted }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    contentView.layer.shadowRadius = 0
    imageView?.contentMode = .scaleAspectFill
  }
}
