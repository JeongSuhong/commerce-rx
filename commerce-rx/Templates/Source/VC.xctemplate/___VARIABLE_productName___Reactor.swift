

import Foundation
import ReactorKit
import RxFlow
import RxRelay


class ___VARIABLE_productName___Reactor: Reactor, Stepper {

  enum Action {
    
  }
  
  enum Mutation {
    
  }
  
  struct State {
    
  }
  
  let initialState: State
  let steps = PublishRelay<Step>()
  
  init() {
    initialState = State()
  }
  
  
  func mutate(action: Action) -> Observable<Mutation> {
//    switch action {
//
//    }
//
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
