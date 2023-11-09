
import Foundation
import UIKit
import RxSwift
import Reusable
import ReactorKit

// MARK: - ViewController

class ProductDetailViewController: BaseViewController, StoryboardBased, StoryboardView {
  
  typealias Reactor = ProductDetailReactor
  
  @IBOutlet weak var navView: ProductDetailNavView!
  @IBOutlet weak var mainView: UIScrollView!
  
  @IBOutlet weak var imagesView: StickyPagerStackView!
  @IBOutlet weak var imagesConst: NSLayoutConstraint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.contentInsetAdjustmentBehavior = .never
  }
  
  func bind(reactor: Reactor) {
    
    reactor.pulse(\.$info)
      .compactMap { $0 }
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, info in
        vc.imagesView.bind(info.images.map { $0.url })
      }.disposed(by: disposeBag)
    
    mainView.rx.contentOffset
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, offset in
        let percentY = (offset.y > 300.0 ? 300.0 : offset.y) / 300.0
        vc.navView.bgView.alpha = percentY
        vc.navView.setScrollPercent(percentY)
        vc.imagesView.scrollOffsetAction.onNext(offset)
      }.disposed(by: disposeBag)
  
    navView.dismissView.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, _ in
        vc.dismissAction()
      }.disposed(by: disposeBag)
  }
}

