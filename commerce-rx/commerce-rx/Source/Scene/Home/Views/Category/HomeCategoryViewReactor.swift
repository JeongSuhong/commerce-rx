

import Foundation
import ReactorKit
import RxFlow
import RxRelay

class HomeCategoryViewReactor: Reactor {
  
  enum Action {
case setInfo([HomeCategorysRes.categoryRes])
  }
  
  enum Mutation {
    case setInfo([HomeCategorysRes.categoryRes])
  }
  
  struct State {
    @Pulse var info: [HomeCategorysRes.categoryRes]
  }

  
  let initialState: State

  init(_ info: [HomeCategorysRes.categoryRes]) {
    initialState = State(info: info)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .setInfo(info):
      return .just(.setInfo(info))
    }
    
    return .empty()
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setInfo(value):
      newState.info = value
    }
    return newState
  }
}
