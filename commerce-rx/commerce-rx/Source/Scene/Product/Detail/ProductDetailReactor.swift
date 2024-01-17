

import Foundation
import ReactorKit
import RxFlow
import RxRelay
import RealmSwift

class ProductDetailReactor: Reactor, Stepper {

  enum Action {
    case refresh
    case setModel(ProductModel)
    case toggleImageInfoOpen
  }
  
  enum Mutation {
    case setStatus(ViewStatus)
    case setInfo(ProductDetailRes)
  case setModel(ProductModel)
    case setImageInfoOpen(Bool)
  }
  
  struct State {
    var status: ViewStatus = .loading
    @Pulse var model: ProductModel?
    @Pulse var info: ProductDetailRes?
    
    var isImageInfoOpen = false
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
      if case .change = status { self?.action.onNext(.setModel(model)) }
    }
  }
  
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      return .concat(.just(.setStatus(.loading)), refresh())
      
    case let .setModel(model):
      return .just(.setModel(model))
      
    case .toggleImageInfoOpen:
      return .just(.setImageInfoOpen(!currentState.isImageInfoOpen))
        
    }

    return .empty()
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setStatus(value):
      newState.status = value
    case let .setInfo(value):
      newState.info = value
    case let .setModel(value):
      newState.model = value
    case let .setImageInfoOpen(value):
      newState.isImageInfoOpen = value
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
