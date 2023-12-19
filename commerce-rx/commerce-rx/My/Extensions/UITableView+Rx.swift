

import Foundation
import RxSwift
import UIKit

public extension Reactive where Base: UITableView {
  var headerHeight: Binder<CGFloat> {
    return Binder(self.base) { v, height in
      if let header = v.tableHeaderView {
        var fixFrame  = header.frame
        fixFrame.size = .init(width: fixFrame.width, height: height)
        header.frame = fixFrame
        v.tableHeaderView = header
      }
    }
  }
}
