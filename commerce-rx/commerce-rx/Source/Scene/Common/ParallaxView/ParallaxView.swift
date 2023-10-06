

import Foundation
import UIKit
import Reusable
import FSPagerView

class ParallaxView: FSPagerViewCell, NibOwnerLoadable {
  
  @IBOutlet weak var mainView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.loadNibContent()
    
    layer.masksToBounds = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
    
    layer.masksToBounds = true
  }
  
  func bind(_ info: Model) {
    mainView.loadImage(info.imageUrl)
    titleLabel.text = info.title
  }
}

extension ParallaxView {
  struct Model {
    let imageUrl: String
    var title: String?
  }
}
