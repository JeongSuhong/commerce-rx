
import Foundation
import UIKit
import Gifu
import Reusable
import BonMot

class CommonErrorView: UIView, NibOwnerLoadable {
  
  @IBOutlet weak var mainView: GIFImageView!
  @IBOutlet weak var mainLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.loadNibContent()
    bind()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
    bind()
  }
  
  private func bind() {
    mainView.animate(withGIFNamed: "error")
    mainLabel.attributedText = "<r>Network Error!!!</r>\n잠시 후 다시 이용해주시기 바랍니다.".styled(with: getStyle())
  }
  
  private func getStyle() -> BonMot.StringStyle {
    let red = NamedStyles.shared.style(forName: "nanumB_16")!.byAdding(
      .color(.init(resource: .coError))
    )
    
    return NamedStyles.shared.style(forName: "nanum_16")!.byAdding(
      .alignment(.center),
      .lineHeightMultiple(1.4),
      .xmlRules([.style("r", red)])
    )
  }
}
