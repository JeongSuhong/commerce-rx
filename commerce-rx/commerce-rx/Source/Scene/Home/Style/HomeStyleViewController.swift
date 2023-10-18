
import Foundation
import UIKit
import RxSwift
import XLPagerTabStrip
import ReusableKit
import Reusable
import ReactorKit

class HomeStyleViewController: BaseViewController, StoryboardBased, StoryboardView, IndicatorInfoProvider {
  
  enum Reusable {
    static let cell = ReusableCell<BaseTableCell<HomeProductView>>()
  }
  
  typealias Reactor = HomeStyleReactor
  
  @IBOutlet weak var headerView: HomeStyleHeaderView!
  
  
  private let itemInfo = IndicatorInfo(title: "스타일")
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return itemInfo
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  func bind(reactor: Reactor) {
    
    headerView.bannerView.rx.didSelected
      .distinctUntilChanged()
      .map { Reactor.Action.selectBanner($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    
    reactor.state.map { $0.status }
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, status in
        vc.loadingView.isHidden = status != .loading
        vc.errorView.isHidden = status != .error
      }.disposed(by: disposeBag)
    
    Observable.combineLatest(reactor.pulse(\.$banners).compactMap{ $0 },
                             self.rx.viewWillLayoutSubviews.take(1))
    .map { $0.0 }
    .observe(on: MainScheduler.asyncInstance)
    .bind(with: self) { vc, banners in
      vc.headerView.bannerView.bind(banners.data.map { ParallaxView.Model(imageUrl: $0.titleImage, title: $0.name) })
    }.disposed(by: disposeBag)
    
    reactor.pulse(\.$categorys)
      .compactMap { $0?.data }
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, info in
        vc.headerView.categoryView.bind(categorys: info)
      }.disposed(by: disposeBag)
    
    // Swipe로 VC가 변경되고 다시 돌아오면 pageView Offset이 Reset 됨!! 깃헙 해결책이 Appear 에서 재호출이라 VC에서 작업.
    Observable.combineLatest(headerView.categoryView.mainView.rx.contentOffset.distinctUntilChanged().throttle(.milliseconds(50), scheduler: MainScheduler.asyncInstance),
                             self.rx.viewWillAppear)
    .map { $0.0 }
    .observe(on: MainScheduler.asyncInstance)
    .bind(with: self) { vc, offset in
      guard let mainView = vc.headerView.categoryView.mainView,
            let pageView = vc.headerView.categoryView.pageView,
            let tintView = vc.headerView.categoryView.pageTintView else { return }
      
      var ratio = mainView.visibleSize.width / mainView.contentSize.width
      ratio = ratio > 0.8 ? 0.8 : (ratio < 0.3 ? 0.3 : ratio)
      
      tintView.snp.remakeConstraints { $0.width.equalTo(pageView.bounds.width * ratio) }
      
      let offsetRatio = offset.x / (mainView.contentSize.width - mainView.visibleSize.width)
      let pageOffset = (pageView.contentSize.width - pageView.visibleSize.width) * offsetRatio
      
      pageView.setContentOffset(.init(x: pageOffset, y: pageView.contentOffset.y), animated: false)
    }.disposed(by: disposeBag)
    
    reactor.pulse(\.$relateProducts)
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, info in
        vc.headerView.relateView.bind(info)
      }.disposed(by: disposeBag)
  }
}





