

import UIKit
import Foundation
import ReactorKit
import Reusable
import ReusableKit
import RxReusableKit

class HomeCategoryView: UIView, NibOwnerLoadable {
  
  enum Reusable {
    static let cell = ReusableCell<BaseCollectionCell<HomeCategoryItem>>()
  }
  
  @IBOutlet weak var mainView: UICollectionView!
  @IBOutlet weak var pageView: UIScrollView!
  @IBOutlet weak var pageTintView: UIView!
  
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
    mainView.automaticallyAdjustsScrollIndicatorInsets = false
    mainView.isPagingEnabled = true
  }
  
  func bind(categorys: [HomeCategorysRes.categoryRes]) {
    disposeBag = DisposeBag()
    
    Observable.just(categorys)
      .bind(to: mainView.rx.items(Reusable.cell)) {
        index, item, cell in
        cell.cellView.bind(item)
      }.disposed(by: disposeBag)
  }
}
