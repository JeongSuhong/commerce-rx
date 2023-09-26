
import Foundation
import UIKit
import RxSwift
import RxCocoa

//extension Reactive where Base: BaseTableView {
//  var isDownScroll: ControlEvent<Bool> {
//    return ControlEvent(events: base.didUpdateScrollAction)
//  }
//}

class BaseTableView: UITableView {
  
//  var didUpdateScrollAction = PublishSubject<Bool>()
//  var disposeBag = DisposeBag()
//  
//  private var beginScrollOffset = CGPoint.zero
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    refreshControl = UIRefreshControl()
//    tableView.separatorStyle = .none
//  }
//  
//  
//  
//  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//    beginScrollOffset = scrollView.contentOffset
//    debugPrint("Start!!! \(beginScrollOffset.y)")
//  }
//  
//  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    let difference = beginScrollOffset.y - scrollView.contentOffset.y
//
//    if difference > 1 {
//      didUpdateScrollAction.onNext(true)
//    } else if difference < -1 || scrollView.contentOffset.y > 0 {
//      didUpdateScrollAction.onNext(false)
//    }
//  }
}
