

import UIKit
import Foundation
import RxGesture
import ReactorKit
import Reusable
import BonMot

class HomeProductView: UIView, NibOwnerLoadable, StoryboardView {
  
  typealias Reactor = HomeProductViewReactor
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var likeView: UIImageView!
  
  @IBOutlet weak var brandLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  @IBOutlet weak var todayDeliveryView: UIView!
  @IBOutlet weak var saleView: UIView!
  @IBOutlet weak var couponView: UIView!
  @IBOutlet weak var couponLabel: UILabel!
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.loadNibContent()
  }
  
  func bind(reactor: Reactor) {
    likeView.rx.tapGesture().when(.recognized)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .map { _ in Reactor.Action.switchLike }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    
    let infoState = reactor.pulse(\.$info)
    infoState
      .compactMap { $0?.mainImage }
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, img in
        vc.mainImageView.loadImage(img)
      }.disposed(by: disposeBag)
    
    infoState
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, info in
        vc.brandLabel.text = info?.brandName
        vc.nameLabel.text = info?.name
        
        let price = info?.price ?? 0
        let originPrice = info?.originPrice ?? 0
        let percent = price >= originPrice ? 0 : price.toPercent(originPrice)
        
        var priceStr = "\(price.formatted())"
        if percent != 0 {
          priceStr = "<e>\(percent)%</e> " + priceStr
        }
        vc.priceLabel.attributedText = priceStr.styled(with: vc.getStyle())
        vc.saleView.isHidden = percent < 50
        vc.todayDeliveryView.isHidden = info?.type != .todayDelivery
        
        vc.couponView.isHidden = info?.benefit == nil
        vc.couponLabel.text = info?.benefit?.getTitle()
      }.disposed(by: disposeBag)
    
    infoState.compactMap { $0?.isLike }
      .distinctUntilChanged()
      .map { $0 ? UIImage(resource: .iconLikeOn) : UIImage(resource: .iconLike) }
      .bind(to: likeView.rx.image)
      .disposed(by: disposeBag)
    
  }
  
  private func getStyle() -> BonMot.StringStyle {
    let error = StringStyle(.color(.init(resource: .coF64444)))
    return StringStyle(
      .font(.nanumGothicBold(size: 18)),
      .color(.init(resource: .coText)),
      .xmlRules([.style("e", error)])
    )
  }

}
