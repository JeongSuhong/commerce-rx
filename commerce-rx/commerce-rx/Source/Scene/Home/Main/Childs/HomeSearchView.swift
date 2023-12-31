
import UIKit
import Foundation
import ReactorKit
import Reusable
import Lottie

class HomeSearchView: UIView, NibOwnerLoadable, StoryboardView {
  
  typealias Reactor = HomeSearchViewReactor
  
  @IBOutlet weak var logoView: LottieAnimationView!
  @IBOutlet weak var searchView: UIView!
  @IBOutlet weak var cartView: UIImageView!
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
  
  func bind(reactor: Reactor) {
    logoView.loopMode = .loop
    logoView.contentMode = .scaleAspectFill
    logoView.play()
  }
}
