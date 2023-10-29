

import Foundation
import ReactorKit
import RxFlow
import RxRelay
import RealmSwift

class HomeProductViewReactor: Reactor {
  
  enum Action {
  case setInfo(ProductModel)
    case switchLike
  }
  
  enum Mutation {
case setInfo(ProductModel)
  }
  
  struct State {
    @Pulse var info: ProductModel?
  }
  
  let initialState: State
  
  private let id: String
  private var token: NotificationToken?
  
  init(id: String) {
    self.id = id
    
    let realm = try! Realm()
    let model = realm.object(ofType: ProductModel.self, forPrimaryKey: id)
    
    initialState = State(info: model)
    if let model { bindRealm(model) }
  }
  
  private func bindRealm(_ model: ProductModel) {
    token = model.observe { [weak self] status in
      switch status {
      case .change:
        self?.action.onNext(.setInfo(model))
        break
      default: break
      }
    }
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .setInfo(let info):
      return .just(.setInfo(info))
      
    case .switchLike:
      return currentState.info?.isLike == true ? setDislike() : setLike()
    }
    
    return .empty()
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setInfo(let value):
      newState.info = value
    }
    return newState
  }
}

extension HomeProductViewReactor {
  private func setLike() -> Observable<Mutation> {
    let id = self.id
    
    let observ: Observable<Void> = .toEmptyTask(
      Task { @MainActor [weak self] in
        let _ = try await ApiProvider.request(ProductApi.like(id))
        
        if let model = self?.currentState.info {
          let realm = try! await Realm()
          try! realm.write {
            model.isLike = true
          }
        }
      }
    )
    
    return observ
      .flatMap { _ -> Observable<Mutation> in
        return .empty()
      }
  }
  
  private func setDislike() -> Observable<Mutation> {
    let id = self.id
    
    let observ: Observable<Void> = .toEmptyTask(
      Task { @MainActor [weak self] in
        let _ = try await ApiProvider.request(ProductApi.dislike(id))
        
        if let model = self?.currentState.info {
          let realm = try! await Realm()
          try! realm.write {
            model.isLike = false
          }
        }
      }
    )
    
    return observ
      .flatMap { _ -> Observable<Mutation> in
        return .empty()
      }
  }
}
