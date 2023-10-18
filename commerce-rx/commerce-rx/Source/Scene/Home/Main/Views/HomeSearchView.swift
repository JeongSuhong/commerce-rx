
import UIKit
import Foundation
import ReactorKit
import Reusable
import Gifu

class HomeSearchView: UIView, NibOwnerLoadable, StoryboardView {
  
  typealias Reactor = HomeSearchViewReactor
  
  @IBOutlet weak var logoView: GIFImageView!
  @IBOutlet weak var searchView: UIView!
  @IBOutlet weak var cartView: UIImageView!
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
  
  func bind(reactor: Reactor) {
    logoView.animate(withGIFNamed: "bar-logo")
  }
  
//  func bind(categorys: [HomeCategorysRes.categoryRes]) {
//    disposeBag = DisposeBag()
//    
//    Observable.just(categorys)
//      .bind(to: mainView.rx.items(Reusable.cell)) {
//        index, item, cell in
//        cell.cellView.bind(item)
//      }.disposed(by: disposeBag)
//  }
}
