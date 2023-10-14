

import UIKit
import Foundation
import ReactorKit
import Reusable

class HomeMoreListView: UIView, NibOwnerLoadable {
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
}
