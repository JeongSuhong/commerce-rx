

import UIKit
import Foundation
import ReactorKit
import Reusable

class StickyPagerImageView: UIView, NibOwnerLoadable {
  
  @IBOutlet weak var mainView: UIImageView!
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.loadNibContent()
  }
}
