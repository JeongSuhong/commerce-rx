import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Reusable

// MARK: - Step

enum ProductStep: Step {
  case main(id: String)
}

// MARK: - Flow

final class ProductFlow: Flow {
  
  var root: Presentable {
    return navigationController
  }
  
  let navigationController: UINavigationController
  
  init(_ nvc: UINavigationController) {
    self.navigationController = nvc
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? ProductStep else { return .none }
    switch step {
    case .main(let id):
      let vc = ProductDetailViewController.instantiate()
      let reactor = ProductDetailReactor(id: id)
      vc.reactor = reactor
      self.navigationController.pushViewController(vc, animated: true)
      return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
  }
}


