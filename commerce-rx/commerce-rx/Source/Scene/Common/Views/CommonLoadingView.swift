

import Foundation
import UIKit
import Lottie
import Reusable

class CommonLoadingView: UIView, NibOwnerLoadable {
  
  @IBOutlet weak var mainView: LottieAnimationView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.loadNibContent()
    bind()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
    bind()
  }
  
  private func bind() {
    mainView.loopMode = .loop
    mainView.contentMode = .scaleAspectFill
    mainView.play()
  }
}
