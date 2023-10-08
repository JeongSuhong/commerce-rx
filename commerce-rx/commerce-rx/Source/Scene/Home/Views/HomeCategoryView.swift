

import UIKit
import Foundation
import ReactorKit
import Reusable

class HomeCategoryView: UIView, NibOwnerLoadable {
  
  @IBOutlet weak var mainImageView: BaseImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.loadNibContent()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
  
  func bind(_ info: HomeCategorysRes.categoryRes) {
    mainImageView.loadImage(info.titleImage)
    titleLabel.text = info.name
  }

}
