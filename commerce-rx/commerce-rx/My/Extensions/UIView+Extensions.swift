
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
  
  func setGradient(colors: [UIColor], locations: [NSNumber] = [0.0, 1.0], start: CGPoint = .init(x: 0.5, y: 1.0), end: CGPoint = .init(x: 0.5, y: 0.0)) {
    self.layer.sublayers?.first(where: { $0.name == "gradient" })?.removeFromSuperlayer()
    
    let layer = CAGradientLayer()
    layer.name = "gradient"
    layer.colors = colors.map { $0.cgColor }
    layer.startPoint = start
    layer.endPoint = end
    layer.locations =  locations
    layer.position = self.center
    layer.frame = self.bounds
    self.layer.insertSublayer(layer, at: 0)
  }
  
  func addShadow(opacity: Float, size: Double, radius: Double, color: UIColor ) {
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = CGSize(width: size, height: size)
      layer.shadowRadius = radius
      layer.masksToBounds = true
  }
}

extension Reactive where Base: UIView {
  var tap: Observable<UITapGestureRecognizer> {
    return base.rx.tapGesture().when(.recognized)
  }
}
