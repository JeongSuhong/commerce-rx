
import Foundation
import UIKit
import RxSwift
import Reusable
import ReactorKit
import ReusableKit
import SnapKit

// MARK: - ViewController

class ProductDetailViewController: BaseViewController, StoryboardBased, StoryboardView {
  
  enum cellType: Int, CaseIterable {
    case imageInfo
  }
  
  enum Reusable {

    
  }
  
  typealias Reactor = ProductDetailReactor
  
  @IBOutlet weak var navView: ProductDetailNavView!
  
  @IBOutlet weak var headerView: UIStackView!
  @IBOutlet weak var imagesView: StickyPagerView!
  @IBOutlet weak var infoView: ProductDetailInfosView!
  
  @IBOutlet weak var mainView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.contentInsetAdjustmentBehavior = .never

    mainView.delegate = self
    mainView.dataSource = self
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
        vc.infoView.reactor = ProductDetailInfosViewReactor(args.0, model: args.1, steps: vc.reactor?.steps ?? .init())
        vc.mainView.reloadData()
      }.disposed(by: disposeBag)
    
    reactor.state.map { $0.status }
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, status in
        vc.loadingView.isHidden = status != .loading
        vc.errorView.isHidden = status != .error
      }.disposed(by: disposeBag)

    navView.dismissView.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, _ in
        vc.dismissAction()
      }.disposed(by: disposeBag)
    
    headerView.rx.contentHeight
      .distinctUntilChanged()
      .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
      .observe(on: MainScheduler.asyncInstance)
      .bind(to: mainView.rx.headerHeight)
      .disposed(by: disposeBag)
  }
}

extension ProductDetailViewController: UITableViewDataSource, UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset
    let percentY = (offset.y > 300.0 ? 300.0 : offset.y) / 300.0    // Y 어디까지 Alpha를 적용할지? : 300
    navView.bgView.alpha = percentY
    navView.setScrollPercent(percentY)
    imagesView.scrollOffsetAction.onNext(offset)
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return ProductDetailSectionView()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let info = self.reactor?.currentState.info
    let model = self.reactor?.currentState.model
    
    return UITableViewCell()
  }
}

