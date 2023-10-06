
import Foundation
import UIKit
import FSPagerView
import Reusable

class CommonBannerView: UIView, NibOwnerLoadable {
  
  @IBOutlet weak var mainView: FSPagerView!
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var moveListLabel: UILabel!
  
  private var images: [String] = []
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }

  func bind(images: [String]) {
    self.images = images
  }
}
