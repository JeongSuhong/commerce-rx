

import UIKit
import Foundation
import ReactorKit
import Reusable

class ProductDetailImageInfoView: UIView, NibOwnerLoadable {
  
  @IBOutlet weak var parentHeightConst: NSLayoutConstraint!
  
  @IBOutlet weak var mainView: UIStackView!
  
  @IBOutlet weak var openView: UIView!
  @IBOutlet weak var openLabel: UILabel!
  @IBOutlet weak var openShadowView: UIView!
  @IBOutlet weak var openArrowView: UIImageView!
  
  var disposeBag = DisposeBag()
  
  private let previewHeight = 500.0
  private var info: [String] = []
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
    
    openShadowView.addShadow(opacity: 0.5, size: 2, radius: 4, color: .white)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.loadNibContent()

    openShadowView.addShadow(opacity: 0.5, size: 2, radius: 4, color: .white)
  }

  
  func bind(_ images: [String]) {
    if info == images { return }
    
    self.info = images
    mainView.reusableViews(count: images.count, targetView: UIImageView.self)
      .enumerated().forEach { index, view in
        let image = images[index]
        view.contentMode = .scaleAspectFit
        view.loadImage(image, fitHeight: true)
      }
  }
  
  func setOpen(_ isOpen: Bool) {
    disposeBag = DisposeBag()
    
    openLabel.text = isOpen ? "상품정보 접기" : "상품정보 더보기"
    openShadowView.isHidden = isOpen
    openArrowView.image = isOpen ? .init(resource: .iconArrowUp) : .init(resource: .iconArrowDown)
    
    // 이미지 로딩 다 되기전에 펼치면 사이즈 안 맞는 이슈 있는데 어떻게 해결할지 고민중
    if isOpen {
      parentHeightConst.constant = mainView.bounds.height
    } else {
      parentHeightConst.constant = previewHeight
    }
    
  }
  
}
