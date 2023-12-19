

import UIKit
import Foundation
import ReactorKit
import Reusable

class ProductDetailSectionView: UIView, NibOwnerLoadable {

  var disposeBag = DisposeBag()
  
  @IBOutlet weak var mainView: UIStackView!
  @IBOutlet weak var lineView: UIView!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.loadNibContent()
  
  }

  func bind(_ info: [String]) {
    mainView.reusableViews(count: info.count, targetView: UILabel.self)
      .enumerated().forEach { index, label in
      let text = info[index]
        label.font = .nanumGothic(size: 14)
        label.textColor = .black
        label.text = text
      }
  }
  
}
