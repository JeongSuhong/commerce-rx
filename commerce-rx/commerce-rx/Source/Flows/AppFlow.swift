
import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift

enum AppStep: Step {
  case dashboardIsRequired
  case onboardingIsRequired
  case onboardingIsComplete
}

class AppFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

  private let window: UIWindow
  private let rootViewController: UIViewController
  
  init(window: UIWindow) {
    let rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()!
    window.rootViewController = rootViewController
    self.rootViewController = rootViewController
    self.window = window
  }
  
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .dashboardIsRequired:
            return navigationToDashboardScreen()
        case .onboardingIsRequired:
            return navigationToOnboardingScreen()
        case .onboardingIsComplete:
            return self.navigationToMainScreen()
        }
    }

    private func navigationToDashboardScreen() -> FlowContributors {
      return .none
    }

    private func navigationToOnboardingScreen() -> FlowContributors {
      return .none
    }

    private func navigationToMainScreen() -> FlowContributors {
      let flow = MainFlow()

      Flows.use(flow, when: .created) { [unowned self] root in
        window.rootViewController = root
      }

      return .one(flowContributor: .contribute(withNextPresentable: flow,
                                               withNextStepper: OneStepper(withSingleStep: MainStep.main)))
    }
}

class AppStepper: Stepper {

    let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    var initialStep: Step {
        return AppStep.dashboardIsRequired
    }

    /// callback used to emit steps once the FlowCoordinator is ready to listen to them to contribute to the Flow
    func readyToEmitSteps() {
      Observable.just(AppStep.onboardingIsComplete)
        .delay(.seconds(1), scheduler: MainScheduler.instance)
        .bind(to: steps)
        .disposed(by: disposeBag)
      //        self.appServices
//            .preferencesService.rx
//            .isOnboarded
//            .map { $0 ? AppStep.onboardingIsComplete : AppStep.onboardingIsRequired }
//            .bind(to: self.steps)
//            .disposed(by: self.disposeBag)
    }
}
