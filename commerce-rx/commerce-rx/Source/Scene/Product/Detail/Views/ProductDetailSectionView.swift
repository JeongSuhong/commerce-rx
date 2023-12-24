

import UIKit
import Foundation
import ReactorKit
import Reusable
import RxSwift


class ProductDetailSectionView: UIView, NibOwnerLoadable {

  var disposeBag = DisposeBag()
  
  @IBOutlet weak var mainView: UIStackView!
  @IBOutlet weak var lineView: UIView!
  
  var indexAction = BehaviorSubject<Int>(value: 0)
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.loadNibContent()
  
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    lineView.translatesAutoresizingMaskIntoConstraints = false

  }
  

  func bind(_ info: [String]) {
    disposeBag = DisposeBag()
        
    mainView.reusableViews(count: info.count, targetView: UILabel.self)
      .enumerated().forEach { index, label in
      let text = info[index]
        label.font = .nanumGothicBold(size: 16)
        label.textAlignment = .center
        label.text = text
        
        label.rx.tap
          .map { _ in index }
          .bind(to: indexAction)
          .disposed(by: disposeBag)
      }
    
    // 초기값에 lineView Width이 변경되면서 Animation이 보이는데 이걸 방지하고싶었음.
    lineView.isHidden = true
    indexAction
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { v, index in
        v.mainView.arrangedSubviews.filter { !$0.isHidden }
          .compactMap { $0 as? UILabel }
          .enumerated().forEach { labelIndex , label in
            label.textColor = labelIndex != index ? .init(resource: .co8E8E92) : .init(resource: .co333333)
            
            if labelIndex == index {
              let originFrame = v.lineView.frame
              
              UIView.animate(withDuration: v.lineView.isHidden ? 0 : 0.3, delay: 0, options: [.curveEaseIn], animations: {
                v.lineView.frame = .init(x: label.frame.origin.x,
                                         y: originFrame.origin.y,
                                         width: label.frame.width,
                                         height: originFrame.height)
              }, completion: { _ in v.lineView.isHidden = false })
            }
          }
      }.disposed(by: disposeBag)
  
  }
}
