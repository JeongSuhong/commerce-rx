

import UIKit
import Foundation
import ReactorKit
import Reusable
import BonMot

class ProductDetailInfosView: UIView, NibOwnerLoadable, StoryboardView {
  
  typealias Reactor = ProductDetailInfosViewReactor
  
  @IBOutlet weak var brandView: UIView!
  @IBOutlet weak var brandIconView: UIImageView!
  @IBOutlet weak var brandLabel: UILabel!
  
  @IBOutlet weak var likeView: UIImageView!
  @IBOutlet weak var shareView: UIImageView!
  
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var ratingView: UIView!
  @IBOutlet weak var ratingConst: NSLayoutConstraint!
  @IBOutlet weak var ratingLabel: UILabel!
  
  @IBOutlet weak var salePriceView: UIView!
  @IBOutlet weak var salePercentLabel: UILabel!
  @IBOutlet weak var originPriceLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  @IBOutlet weak var benefitPriceView: UIView!
  @IBOutlet weak var benefitPriceLabel: UILabel!
  @IBOutlet weak var couponView: UIView!
  
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()

    let maskView = UIImageView(frame: ratingView.frame)
    maskView.image = UIImage(resource: .iconRatingMask)
    maskView.contentMode = .scaleAspectFill
    ratingView.addSubview(maskView)
    ratingView.mask = maskView

  }
  
  func bind(reactor: Reactor) {
    let model = reactor.currentState.model
    let info = reactor.currentState.info
    
    brandIconView.loadImage(model.brandImage ?? "")
    brandLabel.text = model.brandName
    likeView.image = model.isLike ? UIImage(resource: .iconLikeOn) : UIImage(resource: .iconLike)
    categoryLabel.text = model.category.last?.name ?? "-"
    nameLabel.text = model.name
    
    let percent = model.price.toPercent(model.originPrice)
    salePriceView.isHidden = model.originPrice <= info.price
    salePercentLabel.text = "\(percent)%"
    originPriceLabel.attributedText = "<s>\(model.originPrice)</s>".styled(with: getStyle())
    priceLabel.text = "\(model.price.formatted())원"
    
    ratingConst = ratingConst.setMultiplier(multiplier: info.reviewRating / 5.0)
    ratingLabel.text = "(\(info.reviewCount.formatted()))"
    
    benefitPriceView.isHidden = model.benefit == nil
    couponView.isHidden = model.benefit?.type != .coupon
    
    if let benefit = model.benefit {
      switch benefit.type {
      case .coupon:
        benefitPriceLabel.attributedText = "\(model.benefitPrice.formatted())원 <t>쿠폰 적용됨</t>".styled(with: getBenefitStyle())
      case .creditcard:
        benefitPriceLabel.attributedText = "\(model.benefitPrice.formatted())원 <t>할인 적용됨</t>".styled(with: getBenefitStyle())
      }
    }
  }
  
  private func getStyle() -> BonMot.StringStyle {
    return StringStyle(
      .font(.nanumGothic(size: 12)),
      .color(.init(resource: .coAEAEB2)),
      .xmlRules([
        .style("s", StringStyle(.strikethrough(.single, .init(resource: .coAEAEB2))))
      ])
    )
  }
  
  private func getBenefitStyle() -> BonMot.StringStyle {
    let titleStyle = StringStyle(.font(.nanumGothic(size: 12)))
    
    return StringStyle(
      .font(.nanumGothic(size: 18)),
      .color(.init(resource: .coF64444)),
      .xmlRules([
        .style("t", titleStyle)
      ])
    )
  }
}
