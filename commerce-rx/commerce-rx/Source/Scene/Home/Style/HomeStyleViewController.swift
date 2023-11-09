
import Foundation
import UIKit
import RxSwift
import XLPagerTabStrip
import ReusableKit
import Reusable
import ReactorKit

class HomeStyleViewController: BaseViewController, StoryboardBased, StoryboardView, IndicatorInfoProvider {
  
  enum Reusable {
    static let header = ReusableView<BaseCollectionReusableView<HomeStyleHeaderView>>()
    static let cell = ReusableCell<BaseCollectionCell<HomeProductView>>()
  }
  
  typealias Reactor = HomeStyleReactor
  
  @IBOutlet weak var mainView: UICollectionView!
  @IBOutlet weak var moveUpView: UIView!
  
  private let itemInfo = IndicatorInfo(title: "스타일")
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return itemInfo
  }
  
  override func viewDidLoad() {
    mainView.register(Reusable.cell)
    mainView.register(Reusable.header, kind: .header)
    mainView.collectionViewLayout = .compositional(count: 2, height: .fractionalWidth(0.9), itemSpacing: 10, inset: .init(top: 0, leading: 16, bottom: 0, trailing: 16), headerHeight: 150)
    mainView.dataSource = self
    mainView.delegate = self
    
    super.viewDidLoad()
  }
  
  func bind(reactor: Reactor) {
    mainView.rx.itemSelected
      .map { Reactor.Action.selectItem($0.row) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
  
    reactor.state.map { $0.status }
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, status in
        vc.loadingView.isHidden = status != .loading
        vc.errorView.isHidden = status != .error
        
        if status == .none || status == .finish { vc.mainView.reloadData() }
      }.disposed(by: disposeBag)

    mainView.rx.contentOffset
      .map { $0.y < 30 }
      .distinctUntilChanged()
      .bind(to: moveUpView.rx.isHidden)
      .disposed(by: disposeBag)
    
    moveUpView.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, _ in
        vc.mainView.setContentOffset(.zero, animated: true)
      }.disposed(by: disposeBag)
  }
}

extension HomeStyleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.reactor?.currentState.info.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let view = collectionView.dequeue(Reusable.header, kind: kind, for: indexPath)
      bindHeader(view.cellView)
      return view
    default:
      return UICollectionReusableView()
    }
  }
  
  private func bindHeader(_ view: HomeStyleHeaderView) {
    guard let reactor = self.reactor else { return }
    
    view.disposeBag = DisposeBag()
    
    view.relateView.mainView.rx.itemSelected
      .map { Reactor.Action.selectRelateItem($0.row) }
      .bind(to: reactor.action)
      .disposed(by: view.disposeBag)
    
    
    Observable.combineLatest(reactor.pulse(\.$banners).compactMap{ $0 },
                             self.rx.viewWillLayoutSubviews.take(1))
    .map { $0.0 }
    .observe(on: MainScheduler.asyncInstance)
    .bind(with: view) { v, banners in
      v.bannerView.bind(banners.data.map { ParallaxView.Model(imageUrl: $0.titleImage, title: $0.name) })
    }.disposed(by: view.disposeBag)
    
    reactor.pulse(\.$categorys)
      .compactMap { $0?.data }
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: view) { v, info in
        v.categoryView.bind(categorys: info)
      }.disposed(by: view.disposeBag)
    
    // FSPager 에서 VC가 전환될때 Header가 다시 그려지면서 Cell Offset은 복구되나 내부의 ScrollView Offset은 복구되지 않는 듯 함. (or 다시 그리면서 리셋되던가)
    Observable.combineLatest(view.categoryView.mainView.rx.contentOffset.distinctUntilChanged().throttle(.milliseconds(50), scheduler: MainScheduler.asyncInstance),
                             self.rx.viewWillAppear)
    .map { $0.0 }
    .observe(on: MainScheduler.asyncInstance)
    .bind(with: view) { v, offset in
      guard let mainView = v.categoryView.mainView,
            let pageView = v.categoryView.pageView,
            let tintView = v.categoryView.pageTintView else { return }
      
      var ratio = mainView.visibleSize.width / mainView.contentSize.width
      ratio = ratio > 0.8 ? 0.8 : (ratio < 0.3 ? 0.3 : ratio)
      
      tintView.snp.remakeConstraints { $0.width.equalTo(pageView.bounds.width * ratio) }
      
      let offsetRatio = offset.x / (mainView.contentSize.width - mainView.visibleSize.width)
      let pageOffset = (pageView.contentSize.width - pageView.visibleSize.width) * offsetRatio

      pageView.setContentOffset(.init(x: pageOffset, y: pageView.contentOffset.y), animated: false)
    }.disposed(by: view.disposeBag)
    
    reactor.pulse(\.$relateProducts)
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: view) { v, info in
        v.relateView.bind(info)
      }.disposed(by: view.disposeBag)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(Reusable.cell, for: indexPath)
    if let id = self.reactor?.currentState.info[safe: indexPath.row] {
      cell.cellView.reactor = HomeProductViewReactor(id: id)
    }
    return cell
  }
}





