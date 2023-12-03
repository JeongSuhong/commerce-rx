

import Foundation
import ReactorKit
import RxFlow
import RxRelay

class ProductDetailNavViewReactor: Reactor {
  
  enum Action {

  }
  
  enum Mutation {

  }
  
  struct State {

  }

  
  let initialState: State
  private let steps: PublishRelay<Step>
  
  init(steps: PublishRelay<Step>) {
    self.steps = steps
    initialState = State()
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
