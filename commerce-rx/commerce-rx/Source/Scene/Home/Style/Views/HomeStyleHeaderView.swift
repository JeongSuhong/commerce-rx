

import Foundation
import UIKit
import RxSwift
import Reusable
import ReusableKit
import RxReusableKit

class HomeStyleHeaderView: UIView, NibOwnerLoadable {
  
  @IBOutlet weak var mainView: UIStackView!
  @IBOutlet weak var bannerView: ParallaxPagerView!
  @IBOutlet weak var categoryView: HomeCategoryView!
  @IBOutlet weak var relateView: HomeMoreListView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  var disposeBag = DisposeBag()
  
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
    relateView.titleLabel.text = "내가 본 상품의 연관 상품"
    titleLabel.text = "\("-")님을 위한 추천 상품"
  }
}
