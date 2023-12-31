

import Foundation
import UIKit
import SnapKit

class BaseTableCell<view: UIView>: UITableViewCell {
  lazy var cellView = view(frame: bounds)
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.selectionStyle = .none
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
