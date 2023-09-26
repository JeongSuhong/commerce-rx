
import UIKit
import Foundation
import ReactorKit
import Reusable
import Gifu

class HomeSearchView: UIView, NibOwnerLoadable, StoryboardView {
  
  typealias Reactor = HomeSearchViewReactor
  
  @IBOutlet weak var logoView: GIFImageView!
  @IBOutlet weak var searchView: UIView!
  @IBOutlet weak var cartView: UIImageView!
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
  
  func bind(reactor: Reactor) {
  setInit()
    
    
  }
  
  private func setInit() {
    logoView.animate(withGIFNamed: "bar-logo", loopCount: 1)
    
  }
  
}
