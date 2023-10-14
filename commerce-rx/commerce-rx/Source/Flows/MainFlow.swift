
import UIKit
import RxSwift
import RxCocoa
import RxFlow


enum MainStep: Step {
  case main
}

final class MainFlow: Flow {
  
  var root: Presentable { tabBarController }
  
  let tabBarController: UITabBarController
  
  init() {
    let tvc = UITabBarController()

    tvc.view.backgroundColor = .init(resource: .coTabbarBg)
    tvc.tabBar.backgroundColor = .init(resource: .coTabbarBg)
    tvc.tabBar.barTintColor = .init(resource: .coTabbarBg)
    tvc.tabBar.shadowImage = UIImage()
    tvc.tabBar.backgroundImage = UIImage()
    tvc.tabBar.tintColor = .init(resource: .accent)
    tvc.tabBar.unselectedItemTintColor = .init(resource: .coTabbarDisable)
    tvc.tabBar.isTranslucent = false
    
    self.tabBarController = tvc
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? MainStep else { return .none }
    switch step {
    case .main:
      let homeFlow = HomeFlow()
      
      Flows.use(homeFlow, when: .ready) { [unowned self] homeRoot in
        self.tabBarController.viewControllers = [homeRoot]
      }
      
      return .multiple(flowContributors: [
        .contribute(withNextPresentable: homeFlow,
                    withNextStepper: OneStepper(withSingleStep: HomeStep.main))
      ])
    }
  }
}

