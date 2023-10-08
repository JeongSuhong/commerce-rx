
import Foundation
import UIKit
import RxSwift
import FSPagerView
import Reusable
import RxCocoa

extension Reactive where Base: CommonBannerView {
  var didselected: ControlEvent<Int> {
    return ControlEvent(events: base.selectedAction)
  }
}

class CommonBannerView: UIView, NibOwnerLoadable {
  
  @IBOutlet weak var mainView: FSPagerView!
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var moveListLabel: UILabel!
  
  var selectedAction = PublishSubject<Int>()
  
  private var disposeBag = DisposeBag()
  private var images: [String] = []
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  
    mainView.delegate = self
  }

  func bind(images: [String]) {
    disposeBag = DisposeBag()
    self.images = images
  }
}

extension CommonBannerView: FSPagerViewDelegate {
  func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
    self.selectedAction.onNext(index)
  }
  
  func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
    countLabel.text = "\(index) | \(images.count)"
  }
}
