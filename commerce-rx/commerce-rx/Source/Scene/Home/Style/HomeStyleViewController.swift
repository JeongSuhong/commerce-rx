
import Foundation
import UIKit
import RxSwift
import XLPagerTabStrip
import ReusableKit
import Reusable
import ReactorKit

class HomeStyleViewController: BasePagerViewController, StoryboardBased, StoryboardView, IndicatorInfoProvider {
  
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
    mainView.refreshControl = UIRefreshControl()
    
    super.viewDidLoad()
  }
  
  func bind(reactor: Reactor) {
    mainView.refreshControl?.rx.controlEvent(.valueChanged)
      .map { Reactor.Action.refresh(isViewLoading: false) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
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
        
        if status == .none || status == .finish {
          vc.mainView.refreshControl?.endRefreshing()
          vc.mainView.reloadData()
        }
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
    
    // 내부에서 Bounds 값을 가져오기때문에 처음에 frame 계산이 끝난 후 호출할 것!
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
      .bind(with: view) { [unowned self] v, info in
        if let viewReactor = v.categoryView.reactor {
          viewReactor.action.onNext(.setInfo(info))
        } else {
          v.categoryView.reactor = HomeCategoryViewReactor(info)
          v.categoryView.setOffsetForVC(self.rx.viewDidLayoutSubviews)
        }
      }.disposed(by: view.disposeBag)
    
    reactor.pulse(\.$relateProducts)
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: view) { v, info in
        if let viewReactor = v.relateView.reactor {
          viewReactor.action.onNext(.setInfo(info))
        } else {
          v.relateView.reactor = HomeMoreListViewReactor(info)
        }
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





