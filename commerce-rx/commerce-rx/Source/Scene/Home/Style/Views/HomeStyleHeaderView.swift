

import Foundation
import UIKit
import RxSwift
import Reusable
import ReusableKit
import RxReusableKit

class HomeStyleHeaderView: UIView, NibOwnerLoadable {
  
  enum Reusable {
    static let cell = ReusableCell<BaseCollectionCell<HomeCategoryView>>()
  }
  
  @IBOutlet weak var bannerView: ParallaxPagerView!
  @IBOutlet weak var categoryView: UICollectionView!
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
    
    categoryView.register(Reusable.cell)

    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.sectionInset = .init(top: 12, left: 20, bottom: 12, right: 20)
    layout.minimumLineSpacing = 12
    layout.minimumInteritemSpacing = 0
    layout.itemSize = .init(width: 50, height: 70)
    categoryView.collectionViewLayout = layout
    categoryView.automaticallyAdjustsScrollIndicatorInsets = false
    categoryView.isPagingEnabled = true
  }
  
  func bind(categorys: [HomeCategorysRes.categoryRes]) {
    Observable.just(categorys)
      .bind(to: categoryView.rx.items(Reusable.cell)) {
        index, item, cell in
        cell.cellView.bind(item)
      }.disposed(by: disposeBag)
    
  }
}
