

import UIKit
import Foundation
import ReactorKit
import Reusable
import ReusableKit

class HomeMoreListView: UIView, NibOwnerLoadable, StoryboardView {
  
  enum Reusable {
    static let cell = ReusableCell<BaseCollectionCell<HomeProductView>>()
  }
  
  typealias Reactor = HomeMoreListViewReactor
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mainView: UICollectionView!
  @IBOutlet weak var moveAllView: UIView!
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
    
    mainView.register(Reusable.cell)
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    layout.minimumLineSpacing = 12
    layout.minimumInteritemSpacing = 0
    layout.itemSize = .init(width: 130, height: 250)
    mainView.collectionViewLayout = layout
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    mainView.snp.makeConstraints { $0.height.equalTo(250) }
  }
  
  func bind(reactor: Reactor) {
    reactor.state.map { $0.info }
      .bind(to: mainView.rx.items(Reusable.cell)) {
        index, item, cell in
        if cell.cellView.reactor == nil {
          cell.cellView.reactor = HomeProductViewReactor(id: item)
        }
      }.disposed(by: disposeBag)
    
    
  }
}
