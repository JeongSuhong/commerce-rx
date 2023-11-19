

import UIKit
import Foundation
import RxCocoa
import ReactorKit
import Reusable
import ReusableKit
import RxReusableKit

class HomeCategoryView: UIView, NibOwnerLoadable, StoryboardView {
  
  enum Reusable {
    static let cell = ReusableCell<BaseCollectionCell<HomeCategoryItem>>()
  }
  
  typealias Reactor = HomeCategoryViewReactor
  
  @IBOutlet weak var mainView: UICollectionView!
  @IBOutlet weak var pageView: UIScrollView!
  @IBOutlet weak var pageTintView: UIView!
  
  private var pageOffset: CGFloat?
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
    
    mainView.register(Reusable.cell)
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.sectionInset = .init(top: 12, left: 20, bottom: 0, right: 20)
    layout.minimumLineSpacing = 20
    layout.minimumInteritemSpacing = 0
    layout.itemSize = .init(width: 50, height: 70)
    mainView.collectionViewLayout = layout
    mainView.isPagingEnabled = true
  }
  
  func bind(reactor: Reactor) {
    reactor.pulse(\.$info)
      .bind(to: mainView.rx.items(Reusable.cell)) {
        index, item, cell in
        cell.cellView.bind(item)
      }.disposed(by: disposeBag)
    
    mainView.rx.contentOffset
      .distinctUntilChanged()
      .throttle(.milliseconds(100), latest: true, scheduler: MainScheduler.asyncInstance)
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { v, offset in
        guard let mainView = v.mainView,
              let pageView = v.pageView,
              let tintView = v.pageTintView else { return }
        
        var ratio = mainView.visibleSize.width / mainView.contentSize.width
        ratio = ratio > 0.8 ? 0.8 : (ratio < 0.3 ? 0.3 : ratio)
        
        tintView.snp.remakeConstraints { $0.width.equalTo(pageView.bounds.width * ratio) }
        
        let offsetRatio = offset.x / (mainView.contentSize.width - mainView.visibleSize.width)
        let pageOffset = (pageView.contentSize.width - pageView.visibleSize.width) * offsetRatio
        
        pageView.setContentOffset(.init(x: pageOffset, y: pageView.contentOffset.y), animated: false)
        v.pageOffset = pageOffset
      }.disposed(by: disposeBag)
  }
  
  func setOffsetForVC(_ action: ControlEvent<Void>) {
    // Child VC이 변경될 경우 ScrollView Offset이 Reset 되는 이슈가 있다. 이게 가장 확실하게 작동.
    // https://stackoverflow.com/a/17569514
    action.compactMap { [weak self] in self?.pageOffset }
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { v, offset in
        guard let pageView = v.pageView else { return }
        v.pageView.setContentOffset(.init(x: offset, y: pageView.contentOffset.y), animated: false)
      }.disposed(by: disposeBag)
  }
}
