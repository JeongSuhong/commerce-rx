import Foundation
import UIKit
import ReactorKit
import RxFlow
import RxRelay
import RealmSwift

class HomeStyleReactor: Reactor, Stepper {
  
  enum Action {
    case refresh
    case selectBanner(Int)
  }
  
  enum Mutation {
case setStatus(ViewStatus)
    case setRefresh((BannersRes, HomeCategorysRes, ProductListRes))
  }
  
  struct State {
    var status: ViewStatus = .loading
    @Pulse var banners: BannersRes?
    @Pulse var categorys: HomeCategorysRes?
    @Pulse var relateProducts: [String] = []
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
    case .setRefresh(let args):
      newState.banners = args.0
      newState.categorys = args.1
      newState.relateProducts = args.2.data.map { $0.id }

    }
    return newState
  }
}

extension HomeStyleReactor {
  private func refresh() -> Observable<Mutation> {
    let observ: Observable<(BannersRes, HomeCategorysRes, ProductListRes)> = .create { observer in
      let task = Task { @MainActor in
        do {
          async let bannerAction: BannersRes = ApiProvider.requestJson(HomeApi.banners)
          async let categorysAction: HomeCategorysRes = ApiProvider.requestJson(HomeApi.categorys(HomeCategorysReq(type: .home)))
          async let relateProductAction: ProductListRes = ApiProvider.requestJson(ProductApi.list(.init(start: 0, perPage: 20, type: .related)))
          
          let (banners, categorys, relateProducts) = try await (bannerAction, categorysAction, relateProductAction)
          
          let realm = try! await Realm()
          try! realm.write {
            realm.add(relateProducts.data.map { ProductModel($0) }, update: .modified)
          }
          
          observer.onNext((banners, categorys, relateProducts))
          observer.onCompleted()
        } catch {
          observer.onError(error)
        }
      }
      
      return Disposables.create { task.cancel() }
    }
    
    return observ
      .errorHandling()
      .flatMap { args -> Observable<Mutation> in
        return .concat(.just(.setRefresh(args)),
                       .just(.setStatus(.none)))
      }
  }
}

