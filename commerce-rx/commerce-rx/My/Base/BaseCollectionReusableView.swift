

import Foundation
import UIKit
import SnapKit

class BaseCollectionReusableView<view: UIView>: UICollectionReusableView {
  lazy var cellView = view(frame: bounds)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .clear
    addSubview(cellView)
    insetsLayoutMarginsFromSafeArea = false
    layoutMargins = .zero
    
    cellView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
  }
}
