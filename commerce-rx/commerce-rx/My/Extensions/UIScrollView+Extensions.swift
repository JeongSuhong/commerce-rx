
import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
  var contentSize: ControlEvent<CGSize> {
    let source = observe(CGSize.self, "contentSize")
      .compactMap { $0 }
    return ControlEvent(events: source)
  }
}
