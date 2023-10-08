

import Foundation
import Moya
import RxSwift

class ApiProvider {
  static let shared: MoyaProvider<MultiTarget> = {
    let config = URLSessionConfiguration.default
    config.headers = .default
    config.urlCache = URLCache.shared
    config.timeoutIntervalForRequest = 30
    config.httpShouldSetCookies = true
    config.httpCookieStorage = HTTPCookieStorage.shared
    config.urlCredentialStorage = nil
    
    return MoyaProvider<MultiTarget>(
      stubClosure: MoyaProvider.delayedStub(0.5),
      session: Session(configuration: config),
      plugins: [MoyaLoggerPlugin(), AuthPlugin()]
    )
  }()
  
  @discardableResult
  static func request(_ target: ApiTargetType) async throws -> Any? {
    try await withCheckedThrowingContinuation { con in
      ApiProvider.shared.request(MultiTarget(target)) { result in
        switch result {
        case .success(let res):
          con.resume(returning: res.data)
        case .failure(let error):
          con.resume(throwing: error)
        }
        
      }
      
    }
  }
  
  static func requestJson<T: Decodable>(_ target: ApiTargetType) async throws -> T {
    try await withCheckedThrowingContinuation { con in
      ApiProvider.shared.request(MultiTarget(target)) { result in
        switch result {
        case .success(let res):
          do {
            _ = try res.filterSuccessfulStatusCodes()
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let json = try decoder.decode(T.self, from: res.data)
            con.resume(returning: json)
          } catch {
            con.resume(throwing: error)
          }
          
        case .failure(let error):
          con.resume(throwing: error)
        }
      }
    }
  }
}

// MARK: - Custom Handling
extension ObservableType {
  func errorHandling() -> Observable<Element> {
    return `catch` { error in
      switch error as? MoyaError {
      case .underlying:
        _Concurrency.Task {
          // 네트워크 에러 팝업 띄우기
        }
          break
        
      default: break
      }
      
      return self.asObservable()
    }
  }
}



// MARK: - Plugins

struct MoyaLoggerPlugin: PluginType {
  func willSend(_ request: RequestType, target: TargetType) {
#if DEBUG
    guard let httpRequest = request.request else {
      print("[HTTP Request] invalid request")
        return
    }
    
    print("---------------- [ HTTP Request ] ----------------")
    print("URL: \(httpRequest.description)")
    print("TARGET: \(target)")
    print("METHOD: \(httpRequest.httpMethod ?? "Unknown method")")
    
    if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
      print("BODY: \n\(bodyString)")
    }
    print("\n\n")
    #endif
  }
  
  func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    #if DEBUG
    switch result {
    case .success(let res):
      print("---------------- [ HTTP Response ] ----------------")
      print("TARGET: \(target)")
      print("CODE: \(res.statusCode)")
      
      if let resStr = res.data.prettyPrintedJSONString {
        print("RESPONSE DATA: \n\(resStr)")
      }
      print("\n\n")
      
    case .failure(let error):
      print("---------------- [ Network Error ] ----------------")
      print("CODE: \(error.errorCode)")
      print("MESSAGE: \(error.failureReason ?? error.errorDescription ?? "Unkown Error")")
      print("\n\n")
    }
    #endif
  }
}

struct AuthPlugin: PluginType {
  let token = UserDefaults.standard.string(forKey: UserDefaultKeys.accessToken.rawValue) ?? ""
  
  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var request = request
    request.addValue("Bearer" + token, forHTTPHeaderField: "Authorization")
    return request
  }
}

protocol ApiTargetType: TargetType { }
extension ApiTargetType {
  var baseURL: URL { return URL(string: Const.baseUrl)! }
  var headers: [String: String]? { return ["Content-type": "application/json"] }
  var validationType: ValidationType { return .successAndRedirectCodes }
}
