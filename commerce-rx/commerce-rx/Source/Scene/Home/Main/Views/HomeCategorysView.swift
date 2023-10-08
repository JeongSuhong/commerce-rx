

import UIKit
import Foundation
import ReactorKit
import Reusable

class HomeCategorysView: UIView, NibOwnerLoadable, StoryboardView {
  
  typealias Reactor = HomeCategorysViewReactor
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
  
  func bind(reactor: Reactor) {
    
  }

}
