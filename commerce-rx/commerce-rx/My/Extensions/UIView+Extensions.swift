
import UIKit
import RxSwift
import RxGesture

extension UIView {
    @IBInspectable
  var cornerRadius: CGFloat {
    get { self.layer.cornerRadius }
    set {
      self.layer.cornerRadius = newValue
      self.clipsToBounds = newValue > 0
    }
  }
  
    @IBInspectable
    var borderColor: UIColor? {
        get { layer.borderColor.flatMap { UIColor(cgColor: $0) } }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
}

extension Reactive where Base: UIView {
  var tap: Observable<UITapGestureRecognizer> {
    return base.rx.tapGesture().when(.recognized)
  }
}
