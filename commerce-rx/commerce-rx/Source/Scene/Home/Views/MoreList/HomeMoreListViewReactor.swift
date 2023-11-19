

import Foundation
import ReactorKit
import RxFlow
import RxRelay

class HomeMoreListViewReactor: Reactor {
  
  enum Action {
    case setInfo([String])
  }
  
  enum Mutation {
    case setInfo([String])
  }
  
  struct State {
    var info: [String]
  }
  
  
  let initialState: State
  
  init(_ info: [String]) {
    initialState = State(info: info)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .setInfo(let info):
      return .just(.setInfo(info))
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
