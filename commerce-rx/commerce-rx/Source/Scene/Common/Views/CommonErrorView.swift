
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
    mainLabel.attributedText = "<e>Network Error!!!</e>\n잠시 후 다시 이용해주시기 바랍니다.".styled(with: getStyle())
  }
  
  private func getStyle() -> BonMot.StringStyle {
    let error = StringStyle(.color(.init(resource: .coF64444)))

    return StringStyle(
      .font(.nanumGothic(size: 16)),
      .alignment(.center),
      .lineHeightMultiple(1.4),
      .xmlRules([.style("e", error)])
    )
  }
}
