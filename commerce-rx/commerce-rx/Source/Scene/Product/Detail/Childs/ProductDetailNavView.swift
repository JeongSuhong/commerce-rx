

import UIKit
import Foundation
import ReactorKit
import Reusable

class ProductDetailNavView: UIView, NibOwnerLoadable, StoryboardView {
  
  typealias Reactor = ProductDetailNavViewReactor
  
  @IBOutlet weak var bgView: UIView!
  
  @IBOutlet weak var dismissView: UIImageView!
  @IBOutlet weak var homeView: UIImageView!
  @IBOutlet weak var searchView: UIImageView!
  @IBOutlet weak var cartView: UIImageView!
  
  var disposeBag = DisposeBag()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
  
  func bind(reactor: Reactor) {

  }
  
  func setScrollPercent(_ percent: CGFloat) {
    let color = [.white, .init(resource: .co3A3A3C)].intermediate(percentage: percent * 500)
    dismissView.tintColor = color
    homeView.tintColor = color
    searchView.tintColor = color
    cartView.tintColor = color
    
    let bgColor = [.clear, .white].intermediate(percentage: percent * 500)
    bgView.backgroundColor = bgColor
  }

}
