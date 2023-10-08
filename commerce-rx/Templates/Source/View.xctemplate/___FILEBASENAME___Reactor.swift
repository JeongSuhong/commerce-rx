

import Foundation
import ReactorKit
import RxFlow
import RxRelay

class ___FILEBASENAME___: Reactor {
  
  enum Action {

  }
  
  enum Mutation {

  }
  
  struct State {

  }

  
  let initialState: State

  init() {
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
