
import Foundation
import UIKit
import SnapKit

class BaseCollectionCell<view: UIView>: UICollectionViewCell {
  lazy var cellView = view(frame: bounds)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .clear
    self.contentView.backgroundColor = .clear
    
    contentView.addSubview(cellView)
    insetsLayoutMarginsFromSafeArea = false
    cellView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

