
import Foundation
import ReactorKit
import RxFlow
import RxRelay

class ProductDetailInfosViewReactor: Reactor {
  
  enum Action {
    
  }
  
  enum Mutation {

  }
  
  struct State {
    let model: ProductModel
    let info: ProductDetailRes
  }

  
  let initialState: State
  private let steps: PublishRelay<Step>

  init(_ info: ProductDetailRes, model: ProductModel, steps: PublishRelay<Step>) {
    self.steps = steps
    initialState = State(model: model, info: info)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    default: break
    }
    
    return .empty()
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    default: break
    }
    return newState
  }
}
