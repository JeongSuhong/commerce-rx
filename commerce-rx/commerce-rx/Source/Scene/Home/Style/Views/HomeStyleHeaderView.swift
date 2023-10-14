

import Foundation
import UIKit
import RxSwift
import Reusable
import ReusableKit
import RxReusableKit

class HomeStyleHeaderView: UIView, NibOwnerLoadable {

  @IBOutlet weak var bannerView: ParallaxPagerView!
  @IBOutlet weak var categoryView: HomeCategoryView!
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
}
