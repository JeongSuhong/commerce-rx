

import Foundation
import ReactorKit
import RxFlow
import RxRelay
import RealmSwift

class ProductDetailReactor: Reactor, Stepper {

  enum Action {
    case refresh
    case setModel(ProductModel)
  }
  
  enum Mutation {
    case setStatus(ViewStatus)
    case setInfo(ProductDetailRes)
  case setModel(ProductModel)
  }
  
  struct State {
    var status: ViewStatus = .loading
    @Pulse var model: ProductModel?
    @Pulse var info: ProductDetailRes?
  }
  
  let initialState: State
  let steps = PublishRelay<Step>()
  
  private let id: String
  private var token: NotificationToken?
  
  init(id: String) {
    self.id = id
    
    let realm = try! Realm()
    let model = realm.object(ofType: ProductModel.self, forPrimaryKey: id)
    
    initialState = State(model: model)
    if let model { bindRealm(model) }
    
    self.action.onNext(.refresh)
  }
  
  private func bindRealm(_ model: ProductModel) {
    token = model.observe { [weak self] status in
      switch status {
      case .change:
        self?.action.onNext(.setModel(model))
        break
      default: break
      }
    }
  }
  
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      return .concat(.just(.setStatus(.loading)), refresh())
      
    case .setModel(let model):
      return .just(.setModel(model))
      
    }

    return .empty()
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setStatus(let value):
      newState.status = value
    case .setInfo(let value):
      newState.info = value
    case .setModel(let value):
      newState.model = value
    }
    
    return newState
  }
}

extension ProductDetailReactor {
  private func refresh() -> Observable<Mutation> {
    let id = self.id
    
    let observ: Observable<ProductDetailRes> = .toTask(
      Task { @MainActor in
        let res: ProductDetailRes = try await ApiProvider.requestJson(ProductApi.detail(id))
        
        let realm = try! await Realm()
        try realm.write {
          realm.add(ProductModel(res), update: .modified)
        }
        
        return res
      }
    )
    
    return observ
      .flatMap { res -> Observable<Mutation> in
        return .concat(.just(.setInfo(res)),
                       .just(.setStatus(.none)))
      }
  }
}
