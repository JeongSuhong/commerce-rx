

import Foundation
import UIKit
import RxSwift

class BasePagerViewController: BaseViewController, UIScrollViewDelegate {
  @IBOutlet weak var scrollView: UIScrollView?
  
  var isDownScroll = PublishSubject<Bool>()
  
  private var lastContentOffset: CGFloat = 0

  override func viewDidLoad() {
    scrollView?.delegate = self
    
    super.viewDidLoad()
  }
  
  // https://stackoverflow.com/a/34482740
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
      if lastContentOffset > scrollView.contentOffset.y && lastContentOffset < scrollView.contentSize.height - scrollView.frame.height {
        isDownScroll.onNext(false)
      } else if lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0 {
        isDownScroll.onNext(true)
      }
    
      lastContentOffset = scrollView.contentOffset.y
  }
}

