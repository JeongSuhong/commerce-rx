

import Foundation
import UIKit
import Gifu
import Reusable

class CommonLoadingView: UIView, NibOwnerLoadable {
  
  @IBOutlet weak var mainView: GIFImageView!
  
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
    mainView.animate(withGIFNamed: "loading")
  }
}
