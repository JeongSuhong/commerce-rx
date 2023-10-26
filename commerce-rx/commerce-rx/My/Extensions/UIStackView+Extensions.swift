

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UIStackView {
  func reusableViews<T: UIView>(count: Int, targetView: T.Type) -> [T] {
    var result: [T] = .init()
    
    let needChildCount = count - arrangedSubviews.count
    if needChildCount > 0 {
      for _ in 0 ..< needChildCount {
        let view = targetView.init()
        self.addArrangedSubview(view)
      }
    }
    
    arrangedSubviews
      .compactMap { $0 as? T }
      .enumerated()
      .forEach { index, view in
      view.isHidden = index >= count
      
      if !view.isHidden {
        result.append(view)
      }
    }
    
    return result
  }
  
  func subViews<T: UIView>(_ targetView: T.Type) -> [T] {
    return self.arrangedSubviews.compactMap { $0 as? T }.filter { $0.isHidden == false }
  }
  
}

extension Reactive where Base: UIStackView {
  var contentHeight: ControlEvent<CGFloat> {
    let source = observe(CGRect.self, #keyPath(UIView.bounds))
      .compactMap { $0?.size.height }
      .distinctUntilChanged()
    return ControlEvent(events: source)
  }
}
