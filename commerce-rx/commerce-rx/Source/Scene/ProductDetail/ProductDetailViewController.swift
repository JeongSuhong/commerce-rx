
import Foundation
import UIKit
import RxSwift
import Reusable
import ReactorKit

// MARK: - ViewController

// 오늘의 집 스크롤시 사진 위치 유지 + 에이블리 스크롤시 상단 타이틀바 알파 변경 둘다 섞어 넣어보기!

class ProductDetailViewController: BaseViewController, StoryboardBased, StoryboardView {
  
  typealias Reactor = ProductDetailReactor
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func bind(reactor: Reactor) {
    
  }
}

