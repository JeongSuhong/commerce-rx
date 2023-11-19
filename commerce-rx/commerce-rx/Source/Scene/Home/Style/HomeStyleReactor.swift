import Foundation
import UIKit
import ReactorKit
import RxFlow
import RxRelay
import RealmSwift

class HomeStyleReactor: Reactor {
  
  enum Action {
    case refresh(isViewLoading: Bool = true)
    case selectBanner(Int)
    case selectItem(Int)
    case selectRelateItem(Int)
  }
  
  enum Mutation {
case setStatus(ViewStatus)
    case setRefresh((BannersRes, HomeCategorysRes, ProductListRes, ProductListRes))
    case setInfo([String])
  }
  
  struct State {
    var status: ViewStatus = .loading
    @Pulse var banners: BannersRes?
    @Pulse var categorys: HomeCategorysRes?
    @Pulse var relateProducts: [String] = []
    @Pulse var info: [String] = []
  }

  
  let initialState: State
  let steps: PublishRelay<Step>?

  init(steps: PublishRelay<Step>?) {
    self.steps = steps
    initialState = State()
    self.action.onNext(.refresh())
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh(let isViewLoading):
      return .concat(.just(.setStatus(isViewLoading ? .loading : .loadingScroll)), refresh())
      
    case .selectBanner(let index):
      guard let banner = currentState.banners?.data[safe: index] else { break }
      switch banner.type {
      case .url:
        if let url = URL(string: banner.value) {
          UIApplication.shared.open(url, options: [:])
        }
        
      default: break
      }
      
    case .selectItem(let index):
      guard let id = currentState.info[safe: index] else { break }
      steps?.accept(HomeStep.productDetail(id: id))
      
    case .selectRelateItem(let index):
      guard let id = currentState.relateProducts[safe: index] else { break }
      steps?.accept(HomeStep.productDetail(id: id))
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
      newState.info = args.3.data.map { $0.id }
    case .setInfo(let value):
      newState.info = value
    }
    return newState
  }
}

extension HomeStyleReactor {
  private func refresh() -> Observable<Mutation> {
    let observ: Observable<(BannersRes, HomeCategorysRes, ProductListRes, ProductListRes)> = .toTask(
      Task { @MainActor in
        async let bannerAction: BannersRes = ApiProvider.requestJson(HomeApi.banners)
        async let categorysAction: HomeCategorysRes = ApiProvider.requestJson(HomeApi.categorys(HomeCategorysReq(type: .home)))
        async let relateProductAction: ProductListRes = ApiProvider.requestJson(ProductApi.list(.init(start: 0, perPage: 20, type: .related)))
        async let productsAction: ProductListRes = ApiProvider.requestJson(ProductApi.list(.init(start: 0, perPage: 20, type: .none)))
        
        let (banners, categorys, relateProducts, products) = try await (bannerAction, categorysAction, relateProductAction, productsAction)
        
        let realm = try! await Realm()
        try! realm.write {
          realm.add(relateProducts.data.map { ProductModel($0) }, update: .modified)
          realm.add(products.data.map { ProductModel($0) }, update: .modified)
        }
        
        return (banners, categorys, relateProducts, products)
      }
    )
    
    return observ
      .flatMap { args -> Observable<Mutation> in
        return .concat(.just(.setRefresh(args)),
                       .just(.setStatus(.none)))
      }
  }
}

