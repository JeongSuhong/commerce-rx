

import Foundation
import Moya
import RxSwift
import Alamofire

class ApiProvider {
  //MARK: Cookie Provider
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
      session: Session(configuration: config, startRequestsImmediately: false),
      plugins: [MoyaLoggerPlugin()]
    )
  }()
  
  //MARK: Token Provider
  // https://lsj8706.tistory.com/21
    static let tokenShared: MoyaProvider<MultiTarget> = {
      let config = URLSessionConfiguration.default
      config.headers = .default
      config.urlCache = URLCache.shared
      config.timeoutIntervalForRequest = 30
      config.httpShouldSetCookies = false
  
      return MoyaProvider<MultiTarget>(
        stubClosure: MoyaProvider.delayedStub(0.5),
        session: Session(configuration: config, startRequestsImmediately: false, interceptor: AuthInterceptor.shared),
        plugins: [MoyaLoggerPlugin()]
      )
    }()
  
  final class AuthInterceptor: RequestInterceptor {
    static let shared = AuthInterceptor()
    
    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
      guard urlRequest.url?.absoluteString.hasPrefix(Const.baseUrl) == true,
            let accessToken = UserDefaults.standard.value(forKey: UserDefaultKeys.accessToken.rawValue) as? String else {
        completion(.success(urlRequest))
        return
      }
      
      var urlRequest = urlRequest
      urlRequest.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
      completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
      // RefreshToken을 갱신했어도 401이 내려올 경우 retry를 무한루프 탈 수 있다.(거의 없겠지만) 예방할 수 있는 방법 생각해보기.
      guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401,
            let refreshToken = UserDefaults.standard.value(forKey: UserDefaultKeys.refreshToken.rawValue) as? String else {
        completion(.doNotRetryWithError(error))
        return
      }
      
      MoyaProvider<AuthApi>(plugins: [MoyaLoggerPlugin()]).request(.refreshToken(RefreshTokenReq(refreshToken: refreshToken))) { result in
        switch result {
        case .success(let result):
          if let res = try? JSONDecoder().decode(RefreshTokenRes.self, from: result.data) {
            UserDefaults.standard.setValue(res.accessToken, forKey: UserDefaultKeys.accessToken.rawValue)
            UserDefaults.standard.setValue(res.refreshToken, forKey: UserDefaultKeys.refreshToken.rawValue)
            completion(.retry)
          } else {
          //TODO: 로그아웃
            completion(.doNotRetryWithError(error))
          }
        case .failure(let error):
          //TODO: 로그아웃
          completion(.doNotRetryWithError(error))
        }
      }
    }
  }
  
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

protocol ApiTargetType: TargetType { }
extension ApiTargetType {
  var baseURL: URL { return URL(string: Const.baseUrl)! }
  var headers: [String: String]? { return ["Content-type": "application/json"] }
  var validationType: ValidationType { return .successAndRedirectCodes }
}
