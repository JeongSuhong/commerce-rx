

import Foundation
import UIKit
import RxSwift
import Reusable
import ReusableKit
import RxReusableKit

class HomeStyleHeaderView: UIView, NibOwnerLoadable {

  @IBOutlet weak var bannerView: ParallaxPagerView!
  @IBOutlet weak var categoryView: HomeCategoryView!
  @IBOutlet weak var relateView: HomeMoreListView!
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
    
    relateView.titleLabel.text = "내가 본 상품의 연관 상품"
  }
}
