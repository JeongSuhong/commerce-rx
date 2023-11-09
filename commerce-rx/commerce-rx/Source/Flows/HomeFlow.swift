import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Reusable

// MARK: - Step

enum HomeStep: Step {
  case main
  case productDetail(id: String)
}

// MARK: - Flow

final class HomeFlow: Flow {
  
  var root: Presentable {
    return navigationController
  }
  
  let navigationController: UINavigationController
  
  init(_ nvc: UINavigationController? = nil) {
    if let nvc {
      self.navigationController = nvc
    } else {
      let nvc = UINavigationController()
      nvc.setNavigationBarHidden(true, animated: false)
      
      let tabbarImage = UIImage(resource: .iconTabHome)
      let tabBarItem = UITabBarItem(title: "메인", image: tabbarImage, selectedImage: nil)
      
      nvc.tabBarItem = tabBarItem
      self.navigationController = nvc
    }
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? HomeStep else { return .none }
    switch step {
    case .main:
      let vc = HomeViewController.instantiate()
      let reactor = HomeReactor()
      vc.reactor = reactor
      self.navigationController.setViewControllers([vc], animated: false)
      return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
      
    case .productDetail(let id):
      let flow = ProductFlow(self.navigationController)
      Flows.use(flow, when: .created, block: { _ in })
      return .one(flowContributor: .contribute(withNextPresentable: flow, withNextStepper: OneStepper(withSingleStep: ProductStep.main(id: id))))
    }
  }
}


