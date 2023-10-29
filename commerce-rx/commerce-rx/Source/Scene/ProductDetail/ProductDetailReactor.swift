

import Foundation
import ReactorKit
import RxFlow
import RxRelay


class ProductDetailReactor: Reactor, Stepper {

  enum Action {
   case refresh
  }
  
  enum Mutation {
    
  }
  
  struct State {
    
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
      return refresh()
    }

    return .empty()
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
//    switch mutation {
//
//    }
    
    return newState
  }
}

extension ProductDetailReactor {
  private func refresh() -> Observable<Mutation> {
//    let observ: Observable<(BannersRes, HomeCategorysRes, ProductListRes, ProductListRes)> = .create { observer in
//      let task = Task { @MainActor in
//        do {
//          async let bannerAction: BannersRes = ApiProvider.requestJson(HomeApi.banners)
//          async let categorysAction: HomeCategorysRes = ApiProvider.requestJson(HomeApi.categorys(HomeCategorysReq(type: .home)))
//          async let relateProductAction: ProductListRes = ApiProvider.requestJson(ProductApi.list(.init(start: 0, perPage: 20, type: .related)))
//          async let productsAction: ProductListRes = ApiProvider.requestJson(ProductApi.list(.init(start: 0, perPage: 20, type: .none)))
//          
//          let (banners, categorys, relateProducts, products) = try await (bannerAction, categorysAction, relateProductAction, productsAction)
//          
//          let realm = try! await Realm()
//          try! realm.write {
//            realm.add(relateProducts.data.map { ProductModel($0) }, update: .modified)
//            realm.add(products.data.map { ProductModel($0) }, update: .modified)
//          }
//          
//          observer.onNext((banners, categorys, relateProducts, products))
//          observer.onCompleted()
//        } catch {
//          observer.onError(error)
//        }
//      }
//      
//      return Disposables.create { task.cancel() }
//    }
//    
//    return observ
//      .errorHandling()
//      .flatMap { args -> Observable<Mutation> in
//        return .concat(.just(.setRefresh(args)),
//                       .just(.setStatus(.none)))
//      }
    
    return .empty()
  }
}
