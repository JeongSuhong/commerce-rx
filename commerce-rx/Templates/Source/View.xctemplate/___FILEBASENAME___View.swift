

import UIKit
import Foundation
import ReactorKit
import Reusable

class ___FILEBASENAME___: UIView, NibOwnerLoadable, StoryboardView {
  
  typealias Reactor = ___FILEBASENAME___Reactor
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
  
  func bind(reactor: Reactor) {
    
  }

}
