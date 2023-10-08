import Foundation
import UIKit
import ReactorKit
import RxFlow
import RxRelay

class HomeStyleReactor: Reactor, Stepper {
  
  enum Action {
    case refresh
    case selectBanner(Int)
  }
  
  enum Mutation {
case setStatus(ViewStatus)
    case setRefresh(BannersRes, HomeCategorysRes)
  }
  
  struct State {
    var status: ViewStatus = .loading
    @Pulse var banners: BannersRes?
    @Pulse var categorys: HomeCategorysRes?
  }

  
  let initialState: State
  let steps = PublishRelay<Step>()

  init() {
    initialState = State()
    self.action.onNext(.refresh)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      return .concat(.just(.setStatus(.loading)), refresh())
      
    case .selectBanner(let index):
      guard let banner = currentState.banners?.data[safe: index] else { return .empty() }
      switch banner.type {
      case .url:
        if let url = URL(string: banner.value) {
          UIApplication.shared.open(url, options: [:])
        }
        
      default: break
      }

    }
    
    return .empty()
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setStatus(let value):
      newState.status = value
    case .setRefresh(let banners, let categorys):
      newState.banners = banners
      newState.categorys = categorys

    }
    return newState
  }
}

extension HomeStyleReactor {
  private func refresh() -> Observable<Mutation> {
    let observ: Observable<(BannersRes, HomeCategorysRes)> = .create { observer in
      let task = Task { @MainActor in
        do {
          async let bannerAction: BannersRes = ApiProvider.requestJson(HomeApi.banners)
          async let categorysAction: HomeCategorysRes = ApiProvider.requestJson(HomeApi.categorys(HomeCategorysReq(type: .home)))
          
          let (banners, categorys) = try await (bannerAction, categorysAction)
          
          observer.onNext((banners, categorys))
          observer.onCompleted()
        } catch {
          observer.onError(error)
        }
      }
      
      return Disposables.create { task.cancel() }
    }
    
    return observ
      .errorHandling()
      .flatMap { (banners, categorys) -> Observable<Mutation> in
        return .concat(.just(.setRefresh(banners, categorys)),
                       .just(.setStatus(.none)))
      }
    
  }
}

