

import Foundation
import UIKit
import RxSwift

class BaseViewController: UIViewController {
  
  var disposeBag = DisposeBag()
  
  lazy var loadingView: UIView = {
    if let view = self.view.viewWithTag(Const.loadingTag) { return view }
    else {
      let view = CommonLoadingView()
      view.tag = Const.loadingTag
      self.view.addSubview(view)
      view.snp.makeConstraints { $0.edges.equalToSuperview() }
      self.view.bringSubviewToFront(view)
      return view
    }
  }()
  
  lazy var errorView: UIView = {
    if let view = self.view.viewWithTag(Const.errorTag) { return view }
    else {
      let view = CommonErrorView()
      view.tag = Const.errorTag
      self.view.addSubview(view)
      view.snp.makeConstraints { $0.edges.equalToSuperview() }
      self.view.bringSubviewToFront(view)
      return view
    }
  }()
}
