

import Foundation
import RxSwift
import RealmSwift

extension Observable {
  static func toTask<T: Any>(_ processAction: Task<T, Error>, errorAction: ((Error) -> Void)? = nil) -> Observable<T> {
    return .create { observer in
      let task = Task { @MainActor in
        do {
          let res = try await processAction.value
          observer.onNext(res)
          observer.onCompleted()
        } catch {
          errorAction?(error)
          observer.onError(error)
        }
      }
      
      return Disposables.create { task.cancel() }
    }.errorHandling()
  }
  
  static func toEmptyTask(_ processAction: Task<Void, Error>, errorAction: ((Error) -> Void)? = nil) -> Observable<Void> {
    return .create { observer in
      let task = Task { @MainActor in
        do {
          _ = try await processAction.value
          observer.onNext(())
          observer.onCompleted()
        } catch {
          errorAction?(error)
          observer.onError(error)
        }
      }
      
      return Disposables.create { task.cancel() }
    }.errorHandling()
  }
}
