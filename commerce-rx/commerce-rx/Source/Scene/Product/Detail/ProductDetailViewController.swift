
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
  @IBOutlet weak var infoView: ProductDetailInfosView!
  
  @IBOutlet weak var imagesView: StickyPagerStackView!
  @IBOutlet weak var imagesConst: NSLayoutConstraint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.contentInsetAdjustmentBehavior = .never
  }
  
  func bind(reactor: Reactor) {
    
    let infoState = reactor.pulse(\.$info).compactMap { $0 }
    let modelState = reactor.pulse(\.$model).compactMap { $0 }
    infoState
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, info in
        vc.imagesView.bind(info.images.map { $0.url })
      }.disposed(by: disposeBag)
    
    Observable.combineLatest(infoState, modelState)
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, args in
        let info = args.0
        let model = args.1
        
        vc.infoView.reactor = ProductDetailInfosViewReactor(info, model: model, steps: reactor.steps)
      }.disposed(by: disposeBag)
    
    reactor.state.map { $0.status }
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, status in
        vc.loadingView.isHidden = status != .loading
        vc.errorView.isHidden = status != .error
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

