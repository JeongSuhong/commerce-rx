import UIKit
import RxSwift
import RxCocoa
import RxFlow

// MARK: - Step

enum HomeStep: Step {
  case main
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
      
      let tabbarImage = UIImage(named: "icon-tab-home")
      let tabBarItem = UITabBarItem(title: "메인", image: tabbarImage, selectedImage: nil)
      
      nvc.tabBarItem = tabBarItem
      self.navigationController = nvc
    }
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? HomeStep else { return .none }
    switch step {
    case .main:
      let vc = UIStoryboard(name: HomeViewController.className, bundle: nil).instantiateInitialViewController() as! HomeViewController
      let reactor = HomeReactor()
      vc.reactor = reactor
      self.navigationController.setViewControllers([vc], animated: false)
      return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
  }
}


