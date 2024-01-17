
import Foundation
import UIKit
import RxSwift
import Reusable
import ReactorKit
import ReusableKit
import SnapKit
import RxCocoa

// MARK: - ViewController

class ProductDetailViewController: BaseViewController, StoryboardBased, StoryboardView {
  
  enum cellType: Int, CaseIterable {
    case imageInfo, review, inquire
    
    var title: String {
      switch self {
      case .imageInfo: return "상품정보"
      case .review: return "리뷰"
      case .inquire: return "문의"
      }
    }
  }
  
  enum Reusable {
    static let imageInfoCell = ReusableCell<BaseTableCell<ProductDetailImageInfoView>>()
  }
  
  typealias Reactor = ProductDetailReactor
  
  @IBOutlet weak var navView: ProductDetailNavView!
  
  @IBOutlet weak var headerView: UIStackView!
  @IBOutlet weak var imagesView: StickyPagerView!
  @IBOutlet weak var infoView: ProductDetailInfosView!
  
  @IBOutlet weak var mainView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.estimatedRowHeight = 100
    mainView.contentInsetAdjustmentBehavior = .never
    mainView.register(Reusable.imageInfoCell)
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
    
    reactor.state.map { $0.isImageInfoOpen }
      .skip(1)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, isOpen in
        vc.mainView.reloadData()
      }.disposed(by: disposeBag)
    
    
    
  
    mainView.rx.willDisplayCell.map { $0.indexPath.row }
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, row in
        
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
    // 스크롤 시 NavBar 가 위에 덮는 형식이라 Header 고정이 최상단에서 이뤄지고있음!
    let view = ProductDetailSectionView()
    view.bind(cellType.allCases.map { $0.title })
    return view
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
//    return cellType.allCases.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let info = self.reactor?.currentState.info
    let model = self.reactor?.currentState.model
    
    switch cellType(rawValue: indexPath.row) {
    default:
      let cell = tableView.dequeue(Reusable.imageInfoCell, for: indexPath)
      cell.cellView.bind(info?.detailImages.map { $0.url } ?? [])
      cell.cellView.setOpen(self.reactor?.currentState.isImageInfoOpen ?? false)
      
      if let reactor = self.reactor {
        cell.cellView.openView.rx.tap
          .map { _ in Reactor.Action.toggleImageInfoOpen }
          .bind(to: reactor.action)
          .disposed(by: cell.cellView.disposeBag)
      }
      
      return cell
    }
  }
}

